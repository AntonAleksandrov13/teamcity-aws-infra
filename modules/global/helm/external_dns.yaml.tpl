serviceAccount:
 name: external-dns
 annotations:
  eks.amazonaws.com/role-arn: "${role_arn}"
aws:
 region: "${region}"
 zoneType: public
policy: sync
txtOwnerId: "${txt_owner_id}"
#related to https://medium.com/swlh/amazon-eks-setup-external-dns-with-oidc-provider-and-kube2iam-f2487c77b2a1
podSecurityContext:
 fsGroup: 65534
 runAsUser: 0