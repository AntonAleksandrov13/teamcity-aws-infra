module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "17.1.0"
  cluster_name = var.cluster_name
  subnets      = var.eks_master_subnets
  vpc_id       = var.vpc_id

  cluster_version                 = var.cluster_version
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_create_timeout          = var.cluster_create_timeout

  enable_irsa = var.enable_irsa

  map_roles                   = var.map_roles
  manage_aws_auth             = var.manage_aws_auth

  node_groups = var.node_groups

  worker_groups = var.worker_groups

  worker_groups_launch_template = var.worker_groups_launch_template

  workers_group_defaults = {
    pre_userdata = data.template_file.sysctl.rendered
  }

  tags = var.tags
}