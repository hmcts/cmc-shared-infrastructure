data "azurerm_key_vault_secret" "citizen-cert" {
  name = "${var.citizen_external_cert_name}"
  vault_uri = "${var.citizen_external_cert_vault_uri}"
}

data "azurerm_key_vault_secret" "legal-cert" {
  name = "${var.legal_external_cert_name}"
  vault_uri = "${var.legal_external_cert_vault_uri}"
}

locals {
  citizen_cert_suffix = "${var.env != "prod" ? "-citizen" : ""}"
  legal_cert_suffix = "${var.env != "prod" ? "-legal" : ""}"
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

  # vNet connections
  gatewayIpConfigurations = [
    {
      name = "internalNetwork"
      subnetId = "${data.azurerm_subnet.subnet_a.id}"
    },
  ]

  sslCertificates = [
    {
      name = "${var.citizen_external_cert_name}${local.citizen_cert_suffix}"
      data = "${data.azurerm_key_vault_secret.citizen-cert.value}"
      password = ""
    },
    {
      name = "${var.legal_external_cert_name}${local.legal_cert_suffix}"
      data = "${data.azurerm_key_vault_secret.legal-cert.value}"
      password = ""
    }
  ]

  # Http Listeners
  httpListeners = [
    # Citizen
    {
      name = "citizen-http-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort = "frontendPort80"
      Protocol = "Http"
      SslCertificate = ""
      hostName = "${var.citizen_external_hostname}"
    },
    {
      name = "citizen-https-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort = "frontendPort443"
      Protocol = "Https"
      SslCertificate = "${var.citizen_external_cert_name}${local.citizen_cert_suffix}"
      hostName = "${var.citizen_external_hostname}"
    },

    # Legal
    {
      name = "legal-http-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort = "frontendPort80"
      Protocol = "Http"
      SslCertificate = ""
      hostName = "${var.legal_external_hostname}"
    },
    {
      name = "legal-https-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort = "frontendPort443"
      Protocol = "Https"
      SslCertificate = "${var.legal_external_cert_name}${local.legal_cert_suffix}"
      hostName = "${var.legal_external_hostname}"
    }
  ]

  # Backend address Pools
  backendAddressPools = [
    {
      name = "${var.product}-${var.env}"

      backendAddresses = [
        {
          fqdn = "${var.ilbIp}"
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
      probe = "citizen-http-probe"
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
      probe = "citizen-https-probe"
      PickHostNameFromBackendAddress = "False"
      Host = "${var.citizen_external_hostname}"

    }
  ]
  # Request routing rules
  requestRoutingRules = [
    # Citizen
    {
      name = "citizen-http"
      RuleType = "Basic"
      httpListener = "citizen-http-listener"
      backendAddressPool = "${var.product}-${var.env}"
      backendHttpSettings = "backend-80"
    },
    {
      name = "citizen-https"
      RuleType = "Basic"
      httpListener = "citizen-https-listener"
      backendAddressPool = "${var.product}-${var.env}"
      backendHttpSettings = "backend-443"
    },

    # Legal
    {
      name = "legal-http"
      RuleType = "Basic"
      httpListener = "legal-http-listener"
      backendAddressPool = "${var.product}-${var.env}"
      backendHttpSettings = "backend-80"
    },
    {
      name = "legal-https"
      RuleType = "Basic"
      httpListener = "legal-https-listener"
      backendAddressPool = "${var.product}-${var.env}"
      backendHttpSettings = "backend-443"
    }
  ]

  probes = [
    # Citizen
    {
      name = "citizen-http-probe"
      protocol = "Http"
      path = "/"
      interval = 30
      timeout = 30
      unhealthyThreshold = 5
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings = "backend-80"
      host = "${var.citizen_external_hostname}"
    },
    {
      name = "citizen-https-probe"
      protocol = "Https"
      path = "/"
      interval = 30
      timeout = 30
      unhealthyThreshold = 5
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings = "backend-443"
      host = "${var.citizen_external_hostname}"
    },

    # Legal
    {
      name = "legal-http-probe"
      protocol = "Http"
      path = "/"
      interval = 30
      timeout = 30
      unhealthyThreshold = 5
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings = "backend-80"
      host = "${var.legal_external_hostname}"
    },
    {
      name = "legal-https-probe"
      protocol = "Https"
      path = "/"
      interval = 30
      timeout = 30
      unhealthyThreshold = 5
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings = "backend-443"
      host = "${var.legal_external_hostname}"
    }
  ]
}
