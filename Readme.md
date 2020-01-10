# kmd-prod-slot-deploy-example

An example of how to test an app service to check for the existence of a production slot, and how to pass this as a parameter to an ARM template, which will then use this as a condition to ensure that we do not deploy to the production slot if it already exists.

This is in response to our own testing (and subsequent confirmation from Microsoft) from deploying the ARM template to the production slot - If you perform a slot, then in a subsequent release redeploy the app service plan - the production slot will spin up a new process which will cause high response time and possible downtime.


To execute:

.\deploy-resourcegroup.ps1 -ResourceGroupName 'kmd-example-prod-slot' -TemplateFile azuredeploy.json -TemplateParametersFile templateparams.json


What you should observe is the first run through (when the app service has not yet been created) the `shouldDeployProdSlot` setting = true. In the ARM tmeplate there is conditions against the app service plan and app service (production slot only) to only deploy when this setting is true.

Subsequent deployments will not set the `shouldDeployProdSlot` setting, which is defaulted to false so thee apop service and production slot are not deployed to.

### Note - this contains hardcoded resource naming in order to simplify the example.