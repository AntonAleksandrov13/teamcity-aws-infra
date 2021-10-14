terraform {
  backend "s3" {
    key = "iam"
  }
}

locals {
  provider_url = trimprefix(var.oidc_url, "https://")
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
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:cluster-autoscaler-aws-cluster-autoscaler"]
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

module "external-dns-role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.3"

  create_role = true

  role_name = "external-dns"

  tags = {
    Role = "external-dns-with-oidc"
  }

  provider_url = local.provider_url

  role_policy_arns = [
    module.external-dns-policy.arn,
  ]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:external-dns"]
}

module "external-dns-policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4.3"

  name        = "external-dns-policy"
  path        = "/"
  description = "Allow external dns to CRUD A and TXT records"

  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "route53:ChangeResourceRecordSets"
     ],
     "Resource": [
       "arn:aws:route53:::hostedzone/*"
     ]
   },
   {
     "Effect": "Allow",
     "Action": [
       "route53:ListHostedZones",
       "route53:ListResourceRecordSets"
     ],
     "Resource": [
       "*"
     ]
   }
 ]
}
EOF
}
