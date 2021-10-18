#General config
region                = "eu-west-1"
terraform-bucket-name = "terraform-state-teamcity-test-task"
#VPC config
vpc_name        = "teamcity-multi-tenant"
cidr            = "10.0.0.0/20"
public_subnets  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.4.0/22", "10.0.8.0/22", "10.0.12.0/22"]
route53_zones = {
  "teamcity-anton-cloud.com" = {
    comment = "the main zone. all records here created using external-dns"
  }
}
cluster_name = "teamcity-test-eks"
map_users = [
  {
    userarn  = "arn:aws:iam::332319340546:user/anton"
    username = "anton"
    groups   = ["system:masters"]
  },
  {
    userarn  = "arn:aws:iam::332319340546:user/github_actions"
    username = "cicd"
    groups   = ["system:masters"]
  }
]
#TEST VALUES NOT TO BE USED IN PRODUCTION
instance_type               = "t2.medium"
desired_eks_workers_per_asg = 1
min_eks_workers_per_asg     = 0
