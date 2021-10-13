locals {
  provider_url = trimprefix("https://", var.oidc_url)
}

module "cluster-autoscaler-role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.3"

  create_role = true

  role_name = "cluster-autoscaler"

  tags = {
    Role = "cluster-autoscaler-with-oidc"
  }

  provider_url = local.provider_url

  role_policy_arns = [
    module.cluster-autoscaler-policy.arn,
  ]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:cluster-autoscaler"]
}

module "cluster-autoscaler-policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4.3"

  name        = "cluster-autoscaler-policy"
  path        = "/"
  description = "Allow cluster autoscaler to scale ASGs depending on resource requests and usage"

  policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
        "Action": [
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeAutoScalingInstances",
            "autoscaling:DescribeLaunchConfigurations",
            "autoscaling:DescribeTags",
            "autoscaling:SetDesiredCapacity",
            "autoscaling:TerminateInstanceInAutoScalingGroup",
            "ec2:DescribeLaunchTemplateVersions"
        ],
        "Resource": "*",
        "Effect": "Allow"
    }
]
}
EOF
}
