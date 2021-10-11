module "ec2-bastion-server" {
  source   = "cloudposse/ec2-bastion-server/aws"
  version  = "0.28.3"
  name     = "bastion"
  vpc_id   = var.vpc_id
  subnets  = var.subnets
  key_name = aws_key_pair.bastion.id
}
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
#tricky bit. on one hand, I would rather generate this by hand rather than storing it in state and showing it in plan
# on the otherhand, we are focusing on reproducible environment here
resource "aws_key_pair" "bastion" {
  key_name   = "bastion-key"
  public_key = tls_private_key.pk.public_key_openssh
  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./myKey.pem"
  }
}
# TODO: fix storing secrets inside Vault
# provider "vault" {

# }


# resource "vault_generic_secret" "bastion-ssh" {
#   path = "secret/bastion"

#   data_json = <<EOT
# {
# "private_key":   "${replace(tls_private_key.pk.private_key_pem, "\n", "\\n")}"
# }
# EOT
# }

