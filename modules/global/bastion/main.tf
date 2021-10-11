module "ec2-bastion-server" {
  source   = "cloudposse/ec2-bastion-server/aws"
  version  = "0.28.3"
  name     = "bastion"
  vpc_id   = var.vpc_id
  subnets  = var.subnets
  key_name = aws_key_pair.bastion.id
}

resource "aws_key_pair" "bastion" {
  key_name   = "bastion-key"
  public_key = var.public_key
}
