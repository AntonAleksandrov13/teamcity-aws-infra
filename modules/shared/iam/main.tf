locals {
  provider_url = trimprefix(var.oidc_url, "https://")
  tenant_name  = replace(var.tenant_name, "/\\W|_|\\s/", "")

  server_role_name = "${var.tenant_name}-server-role"
  agent_role_name  = "${var.tenant_name}-agent-role"

  server_policy_name = "${var.tenant_name}-server-policy"
  agent_policy_name  = "${var.tenant_name}-agent-policy"

}
#Teamcity server
module "tenant-server-role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.3"

  create_role = true

  role_name = local.server_role_name

  provider_url = local.provider_url

  role_policy_arns              = []
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.tenant_namespace}:${var.tenant_server_serviceaccount}"]
}

data "template_file" "tenant-server-policy" {
  template = file("../../../modules/shared/iam/server-policy.json.tpl")
  vars = {
    resource = var.tenant_bucket_arn
  }
}

resource "aws_iam_role_policy" "tenant-server-policy" {
  name   = local.server_policy_name
  role   = module.tenant-server-role.iam_role_name
  policy = data.template_file.tenant-server-policy.rendered
}

#Teamcity agent
module "tenant-agent-role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.3"

  create_role = true

  role_name = local.agent_role_name

  provider_url = local.provider_url

  role_policy_arns              = []
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.tenant_namespace}:${var.tenant_agent_serviceaccount}"]
}

data "template_file" "tenant-agent-policy" {
  template = file("../../../modules/shared/iam/agent-policy.json.tpl")
  vars = {
    resource = var.tenant_bucket_arn
  }
}

resource "aws_iam_role_policy" "tenant-agent-policy" {
  name   = local.agent_policy_name
  role   = module.tenant-agent-role.iam_role_name
  policy = data.template_file.tenant-agent-policy.rendered
}
