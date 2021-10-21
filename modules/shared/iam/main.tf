locals {
  provider_url     = trimprefix(var.oidc_url, "https://")
  server_role_name = "${var.tenant_name}-server-role"
  agent_role_name  = "${var.tenant_name}-agent-role"

  server_policy_name = "${var.tenant_name}-server-policy"
  agent_policy_name  = "${var.tenant_name}-agent-policy"

}
#Teamcity server
module "tenant_server_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.3"

  create_role = true

  role_name = local.server_role_name

  provider_url = local.provider_url

  role_policy_arns              = []
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.tenant_namespace}:${var.tenant_server_serviceaccount}"]
}

data "template_file" "tenant_server_policy" {
  template = file("${path.module}/server_policy.json.tpl")
  vars = {
    resource = var.tenant_bucket_arn
  }
}

resource "aws_iam_role_policy" "tenant_server_policy" {
  name   = local.server_policy_name
  role   = module.tenant_server_role.iam_role_name
  policy = data.template_file.tenant_server_policy.rendered
}

#Teamcity agent
module "tenant_agent_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.3"

  create_role = true

  role_name = local.agent_role_name

  provider_url = local.provider_url

  role_policy_arns              = []
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.tenant_namespace}:${var.tenant_agent_serviceaccount}"]
}

data "template_file" "tenant_agent_policy" {
  template = file("${path.module}/agent_policy.json.tpl")
  vars = {
    resource = var.tenant_bucket_arn
  }
}

resource "aws_iam_role_policy" "tenant_agent_policy" {
  name   = local.agent_policy_name
  role   = module.tenant_agent_role.iam_role_name
  policy = data.template_file.tenant_agent_policy.rendered
}
