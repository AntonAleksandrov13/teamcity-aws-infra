#General config
region = "eu-west-1"
terraform-bucket-name = "terraform-state-teamcity-test-task"
#VPC config
vpc_name = "teamcity-multi-tenant"
cidr = "10.0.0.0/20"
azs = [ "eu-west-1a", "eu-west-1b", "eu-west-1c" ]
public_subnets = [ "10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
private_subnets = [ "10.0.4.0/22", "10.0.8.0/22", "10.0.12.0/22" ]