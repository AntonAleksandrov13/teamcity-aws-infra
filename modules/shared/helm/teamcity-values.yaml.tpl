# Default values for teamcity.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.
server:
  image:
    tag: latest
  plugins:
    teamcity-oauth-1.1.6.zip: https://github.com/pwielgolaski/teamcity-oauth/releases/download/teamcity-oauth-1.1.6/teamcity-oauth-1.1.6.zip
    teamcity-kubernetes-plugin.zip: https://teamcity.jetbrains.com/guestAuth/app/rest/builds/buildType:TeamCityPluginsByJetBrains_TeamCityKubernetesPlugin_Build20172x,tags:release/artifacts/content/teamcity-kubernetes-plugin.zip

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
    port: ""
    host: ${db_host}

  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: "${server_role_arn}"

      
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: selfsigned-cluster-issuer
      cert-manager.io/common-name: ${common_name}
    hosts:
      - host: ${common_name}
        paths:
          - backend:
              service:
                name: ${service_name}
                port:
                  name: web
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
