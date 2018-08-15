data "azurerm_key_vault_secret" "citizen-cert" {
  name = "${var.citizen_external_cert_name}"
  vault_uri = "${var.citizen_external_cert_vault_uri}"
}

//APPLICATION GATEWAY RESOURCE FOR ENV=A
module "appGwSouth" {
  source = "git@github.com:hmcts/cnp-module-waf?ref=stripDownWf"
  env = "${var.env}"
  subscription = "${var.subscription}"
  location = "${var.location}"
  wafName = "${var.product}"
  resourcegroupname = "${azurerm_resource_group.rg.name}"
  team_name = "${var.team_name}"
  team_contact = "${var.team_contact}"
  destroy_me = "false"
  ilbIp = "${module.appServicePlanA.ilbIp}"

  # vNet connections
  gatewayIpConfigurations = [
    {
      name = "internalNetwork"
      subnetId = "${data.azurerm_subnet.subnet_a.id}"
    },
  ]

  sslCertificates = [
    {
      name = "STAR-${var.env}-platform-hmcts-net"
      data = "${data.azurerm_key_vault_secret.citizen-cert.value}"
      password = ""
    }
  ]

  # Http Listeners
  httpListeners = [
    {
      name = "${var.product}-http-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort = "frontendPort80"
      Protocol = "Http"
      SslCertificate = ""
      hostName = "${var.citizen_external_hostname}"
    },
    {
      name = "${var.product}-https-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort = "frontendPort443"
      Protocol = "Https"
      SslCertificate = "STAR-${var.env}-platform-hmcts-net"
      hostName = "${var.citizen_external_hostname}"
    },
  ]

  # Backend address Pools
  backendAddressPools = [
    {
      name = "citizen-frontend-${var.env}"

      backendAddresses = [
        {
          fqdn = "${module.appServicePlanA.ilbIp}"
        },
      ]
    },
  ]

  backendHttpSettingsCollection = [
    {
      name = "backend-80"
      port = 80
      Protocol = "Http"
      CookieBasedAffinity = "Disabled"
      AuthenticationCertificates = ""
      probeEnabled = "True"
      probe = "http-probe"
      PickHostNameFromBackendAddress = "False"
      HostName = "${var.citizen_external_hostname}"
    },
    {
      name = "backend-443"
      port = 443
      Protocol = "Https"
      CookieBasedAffinity = "Disabled"
      AuthenticationCertificates = "ilbCert"
      probeEnabled = "True"
      probe = "https-probe"
      PickHostNameFromBackendAddress = "True"
      Host = "${var.citizen_external_hostname}"

    }
  ]
  # Request routing rules
  requestRoutingRules = [
    {
      name = "${var.product}-http"
      RuleType = "Basic"
      httpListener = "${var.product}-http-listener"
      backendAddressPool = "${var.product}-frontend-${var.env}"
      backendHttpSettings = "backend-80"
    },
    {
      name = "${var.product}-https"
      RuleType = "Basic"
      httpListener = "${var.product}-https-listener"
      backendAddressPool = "${var.product}-frontend-${var.env}"
      backendHttpSettings = "backend-443"
    },
  ]

  probes = [
    {
      name = "http-probe"
      protocol = "Http"
      path = "/"
      interval = 30
      timeout = 30
      unhealthyThreshold = 3
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings = "backend-80"
      host = "${var.citizen_external_hostname}"
    },
    {
      name = "https-probe"
      protocol = "Https"
      path = "/"
      interval = 30
      timeout = 30
      unhealthyThreshold = 3
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings = "backend-443"
      host = "${var.citizen_external_hostname}"
    }
  ]
}