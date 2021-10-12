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

  map_users                   = var.map_users
  manage_aws_auth             = var.manage_aws_auth

  worker_groups = [
    for subnet in var.eks_worker_subnets :
    {
      key_name             = aws_key_pair.eks-worker-key.id
      instance_type        = var.instance_type
      asg_max_size         = var.max_eks_workers_per_asg
      asg_desired_capacity = var.desired_eks_workers_per_asg
      asg_min_size         = var.min_eks_workers_per_asg
      subnets              = [subnet]
      kubelet_extra_args   = "--node-labels=cluster=${var.cluster_name} --kube-reserved cpu=250m,memory=1Gi,ephemeral-storage=1G --system-reserved cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi --eviction-hard memory.available<500Mi,nodefs.available<10%"
      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
          "propagate_at_launch" = "false"
          "value"               = "true"
        }
      ]
    }
  ]
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
#tricky bit. on one hand, I would rather generate this by hand rather than storing it in state and showing it in plan
# on the otherhand, we are focusing on reproducible environment here
resource "aws_key_pair" "eks-worker-key" {
  key_name   = "eks-worker-key"
  public_key = tls_private_key.pk.public_key_openssh
  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./eks-worker-key.pem"
  }
}