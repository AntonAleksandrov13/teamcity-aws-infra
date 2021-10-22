# what are these modules? why not just use a single module to provision everything?

These modules ensure separation of concerns accross infrastructure. It would be a hell to manage a single module for this system as it can grow with additions of new feature.

In addition, this structure ensures that we can separate modules in the future by following multirepo idea. However, if monorepo is your choice - simple add more modules and enable them in either `global_infra.tf` or `tenant_infra.tf`
s