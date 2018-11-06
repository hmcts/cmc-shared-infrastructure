# cmc-shared-infrastructure

This module sets up the shared infrastructure for CMC.

## Variables

### Configuration

The following parameters are required by this module

- `env` The environment of the deployment, such as "prod" or "sandbox".
- `tenant_id` The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.
- `jenkins_AAD_objectId` The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault.

The following parameters are optional

- `product` The (short) name of the product. Default is "cmc". 
- `location` The location of the Azure data center. Default is "UK South".
- `appinsights_location` Location for Application Insights. Default is "West Europe".
- `application_type` Type of Application Insights (Web/Other). Default is "Web".

### Output

- `appInsightsInstrumentationKey` The instrumentation key for the application insights instance.
- `vaultName` The name of the key vault.

## Usage Notes

This module requires a secret to be present in the key vault in order to execute successfully. Since the vault is created by this project itself, the first such attempt is guaranteed to fail. To set up a new environment then:

1. Execute the project.
   * The key vault and application insights resources will be created.
   * The bulk print fail action group and associated alert will fail.
   * The PDF fail action group and associated alert will fail.
2. Manually add the `bulk-print-failure-email` secret with a single email address; this is where alerts about bulk print failures will be sent.
3. Manually add the `pdf-failure-email` secret with a single email address; this is where alerts about PDF failures will be sent.
4. Execute the project again.
   * The key vault and application insights resources already exist and will be skipped.
   * The bulk print fail action group and associated alert will be successfully defined.
   * The PDF fail action group and associated alert will be successfully defined.
