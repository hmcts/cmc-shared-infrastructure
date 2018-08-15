data "azurerm_key_vault_secret" "cert" {
  name      = "STAR-saat-platform-hmcts-net"
  vault_uri = "https://infra-vault-${var.subscription}.vault.azure.net/"
}

//APPLICATION GATEWAY RESOURCE FOR ENV=A
module "appGwSouth" {
  source             = "git@github.com:hmcts/moj-module-waf?ref=stripDownWf"
  env                = "${var.env}"
  subscription       = "${var.subscription}"
  location           = "${var.location}"
  wafName            = "${var.product}-appGateway"
  resourcegroupname  = "${azurerm_resource_group.rg.name}"
  team_name          = "${var.team_name}"
  team_contact       = "${var.team_contact}"
  destroy_me         = "false"
  ilbIp              = "${module.appServicePlanA.ilbIp}"
  //storageAccountName = "${var.product}sa"

  # vNet connections
  gatewayIpConfigurations = [
    {
      name     = "internalNetwork"
      subnetId = "${data.azurerm_subnet.subnet_a.id}"
    },
  ]

  # ssl cert - this is an aribitrary unused cert which is over written.
    sslCertificates = [
    {
      name = "STAR-${var.env}-platform-hmcts-net"
      data = "${data.azurerm_key_vault_secret.cert.value}"
      password = ""
    }
  ]

  # Http Listeners
  httpListeners = [
    {
      name                    = "${var.product}-http-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort            = "frontendPort80"
      Protocol                = "Http"
      SslCertificate          = ""
      hostName                = "${var.product}.${var.env}.platform.hmts.net"
    },
    {
      name                    = "${var.product}-https-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort            = "frontendPort443"
      Protocol                = "Https"
      SslCertificate          = "STAR-${var.env}-platform-hmcts-net"
      hostName                = "${var.product}.${var.env}.platform.hmts.net"
    },
  ]

  # Backend address Pools
  backendAddressPools = [
    {
      name = "${var.product}-frontend-${var.env}"

      backendAddresses = [
        {
          fqdn = "${module.appServicePlanA.ilbIp}" 
        },
      ]
    },
  ]

  backendHttpSettingsCollection = [
    {
      name                           = "backend-80-nocookies"
      port                           = 80
      Protocol                       = "Http"
      CookieBasedAffinity            = "Disabled"
      AuthenticationCertificates     = ""
      probeEnabled                   = "True"
      probe                          = "http-probe"
      PickHostNameFromBackendAddress = "False"
      HostName                           = "${var.product}.${var.env}.platform.hmts.net"
    },
    {
      name                           = "backend-443-nocookies"
      port                           = 443
      Protocol                       = "Https"
      CookieBasedAffinity            = "Disabled"
      AuthenticationCertificates     = "ilbCert"
      probeEnabled                   = "True"
      probe                          = "https-probe"
      PickHostNameFromBackendAddress = "True"
      Host                           = "${var.product}.${var.env}.platform.hmts.net"

    }
  ]
  # Request routing rules
  requestRoutingRules = [
    {
      name                = "${var.product}-http"
      RuleType            = "Basic"
      httpListener        = "${var.product}-http-listener"
      backendAddressPool  = "${var.product}-frontend-${var.env}"
      backendHttpSettings = "backend-80-nocookies"
    },
    {
      name                = "${var.product}-https"
      RuleType            = "Basic"
      httpListener        = "${var.product}-https-listener"
      backendAddressPool  = "${var.product}-frontend-${var.env}"
      backendHttpSettings = "backend-443-nocookies"
    },
  ]

     probes = [
    {
      name               = "http-probe"
      protocol           = "Http"
      path               = "/health"
      interval           = 30
      timeout            = 30
      unhealthyThreshold = 3
      # Host               = "${var.product}.${var.env}.platform.hmts.net"
      # Can be used if backed is resolvable in DNS
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings                 = "backend-80-nocookies"
      host = "moneyclaims.${var.env}.platform.hmcts.net"
    }
  ,
    {
      name               = "https-probe"
      protocol           = "Https"
      path               = "/health"
      interval           = 30
      timeout            = 30
      unhealthyThreshold = 3
      # Can be used if backed is resolvable in DNS
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings                 = "backend-443-nocookies"
      host = "moneyclaims.${var.env}.platform.hmcts.net"
    }
   ]
}