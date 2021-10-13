autoDiscovery:
    clusterName: "${cluster_name}"
awsRegion: "${region}"
rbac:
 serviceAccount:
  annotations:
   eks.amazonaws.com/role-arn: "${role_arn}"
  create: true
  automountServiceAccountToken: true