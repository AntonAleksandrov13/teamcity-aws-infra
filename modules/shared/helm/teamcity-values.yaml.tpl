# Default values for teamcity.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.
server:
  image:
    tag: latest
  plugins:
    teamcity-oauth-1.1.6.zip: https://github.com/pwielgolaski/teamcity-oauth/releases/download/teamcity-oauth-1.1.6/teamcity-oauth-1.1.6.zip
    s3-artifact-storage.zip: https://teamcity.jetbrains.com/guestAuth/app/rest/builds/id:2901620/artifacts/content/s3-artifact-storage.zip
  internal_properties:
    storage.s3.bucket.name: ${bucket}
    storage.s3.acl: bucket-owner-full-control
    storage.s3.bucket.prefix: ${prefix}
    teamcity.s3.use.cloudfront.enabled: true
    storage.s3.cloudfront.enabled: true
    
  logging:
    enabled: false

  networkPolicy:
    enabled: false

  persistentDataDir:
    enabled: true
    accessModes:
      - ReadWriteMany
    size: 3Gi
    storageClass: "${storage_class}"
  db:
    user: ${db_user}
    password: ${db_password}
    name: ${db_name}
    host: ${db_host}

  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: "${server_role_arn}"

  ingress:
    enabled: true
    className: nginx
    annotations:
      cert-manager.io/cluster-issuer: selfsigned-cluster-issuer
      cert-manager.io/common-name: ${common_name}
    hosts:
      - host: ${common_name}
        paths:
          - path: /
            pathType: ImplementationSpecific
    tls:
      - hosts:
          - ${common_name}
        secretName: ${common_name}
  resources:
    {}
    # limits:
    #   cpu: "700m"
    #   memory: "550Mi"
    # requests:
    #   cpu: "350m"
    #   memory: "400Mi"

agent:
  replicaCount: 1
  image:
    tag: latest

  logging:
    enabled: false

  serviceAccount:
    create: true
    annotations:
      eks.amazonaws.com/role-arn: "${agent_role_arn}"

  resources:
    {}
    # limits:
    #   cpu: "700m"
    #   memory: "550Mi"
    # requests:
    #   cpu: "350m"
    #   memory: "400Mi"

global:
  resource_quota:
    enabled: false
    cpu: "10000"
    memory: 10Gi
    pods: "10"
