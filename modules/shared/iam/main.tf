locals {
  provider_url   = trimprefix(var.oidc_url, "https://")
  tenant_name    = replace(var.tenant_name, "/\\W|_|\\s/", "")

  server_role_name      = "${local.tenant_name}-server-role"
  agent_role_name      = "${local.tenant_name}-agent-role"

  server_policy_name = "${local.tenant_name}-server-policy"
  agent_policy_name = "${local.tenant_name}-agent-policy"

}

module "tenant-server-role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.3"

  create_role = true

  role_name = local.server_role_name

  provider_url = local.provider_url

  role_policy_arns = []
  oidc_fully_qualified_subjects = ["system:serviceaccount:${tenant_namespace}:${tenant_server_serviceaccount}"]
}

data "template_file" "tenant-server-policy" {
  template = file("../../../modules/shared/s3/mercury-server-policy.json.tpl")
  vars = {
    oidc      = var.oidc
    account   = var.account
    namespace = var.external_dns_namespace
    role      = var.external_dns_service_acc
  }
}

resource "aws_iam_role_policy" "policy" {
  name   = "ODIS.S3.${var.env}.Access.policy"
  role   = aws_iam_role.odis_assume_role.id
  policy = data.template_file.odis_s3_bucket_access.rendered
}
