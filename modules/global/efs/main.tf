resource "aws_kms_key" "k8s_efs" {
  tags        = { "Name" = "${var.cluster_name}-k8s-efs" }
  description = "KMS key used by EFS"
}

resource "aws_efs_file_system" "k8s_efs" {
  tags                            = { "Name" = "${var.cluster_name}-k8s-efs" }
  encrypted                       = true
  kms_key_id                      = aws_kms_key.k8s_efs.arn
  throughput_mode                 = var.throughput_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
}

resource "aws_efs_mount_target" "k8s_efs" {
  file_system_id = aws_efs_file_system.k8s_efs.id
  count          =  length(var.eks_worker_subnets)

  subnet_id       = element(var.eks_worker_subnets, count.index)
  security_groups = [aws_security_group.k8s_efs.id]
}

resource "aws_security_group" "k8s_efs" {
  tags        = { "Name" = "${var.cluster_name}-k8s-efs" }
  name        = "${var.cluster_name}-k8s-efs-sg"
  description = "Security group for k8s efs target mounts"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ingress_efs_k8s_workers" {
  security_group_id        = aws_security_group.k8s_efs.id
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = var.worker_security_group_id
}
