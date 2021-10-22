# what is an environment?
Basically, it's a single instance of global infra plus all enabled tenants installed. Conventially, one environment = one AWS account, however if region is changed inside backend configurations or names of components adjusted correspondingly one AWS account can hold as many environments as needed. That also depends on resource limits.

# what comes first in environment?
`global` comes first, as it provides the base for tenants.

# why separate global and tenant?
Potentially, global will not change as much as tenant infrastructure, thus we need to avoid rebuild static components of the system.

# how to create a tenant?
Relatively simple. A new folder with the name of the tenant needs to be created with `terraform.tfvars` indicating configurations for this tenant. Alongside, `variables.tf` need to be copied from other tenants. Potentially, I would separate this components and use symlinks, so copying can be prevented.
It's also rrequired to add `config.tf` to create a tenant state in the configured S3.

# final note
`tenantone` is a sample tenant used for testing this, thus it does not have accurate representation of a tenant in production ready environment.