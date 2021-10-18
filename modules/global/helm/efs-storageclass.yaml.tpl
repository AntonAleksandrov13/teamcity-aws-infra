kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: efs-sc
provisioner: efs.csi.aws.com
mountOptions:
  - tls
parameters:
  provisioningMode: efs-ap
  fileSystemId: ${fs_id}
  directoryPerms: "1000"
  gidRangeStart: "999"
  gidRangeEnd: "1001"
