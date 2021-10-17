# Default values for teamcity.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.
server:
  replicaCount: 1
  image:
    repository: jetbrains/teamcity-server
    pullPolicy: IfNotPresent
    # Overrides the image tag whose default is the chart appVersion.
    tag: latest
  plugins:
    teamcity-oauth-1.1.6.zip: https://github.com/pwielgolaski/teamcity-oauth/releases/download/teamcity-oauth-1.1.6/teamcity-oauth-1.1.6.zip
    teamcity-kubernetes-plugin.zip: https://teamcity.jetbrains.com/guestAuth/app/rest/builds/buildType:TeamCityPluginsByJetBrains_TeamCityKubernetesPlugin_Build20172x,tags:release/artifacts/content/teamcity-kubernetes-plugin.zip
  imagePullSecrets: []
  nameOverride: ""
  fullnameOverride: ""

  logging:
    enabled: true

  networkPolicy:
    enabled: true

  persistentDataDir:
    enabled: true
    accessModes:
      - ReadWriteMany
    size: 3Gi
    storageClass: "manual"
  db:
    user: root
    password: db-password
    name: db-name
    port: 3306
    host: some-db-mysql

  serviceAccount:
    # Specifies whether a service account should be created
    create: true
    # Annotations to add to the service account
    annotations: {}
    # The name of the service account to use.
    # If not set and create is true, a name is generated using the fullname template
    name: teamcity-server

  podAnnotations: {}

  podSecurityContext:
    fsGroup: 1000
  securityContext: {}

  service:
    type: ClusterIP
    port: 80

  ingress:
    enabled: false
    className: ""
    annotations:
      {}
      # kubernetes.io/ingress.class: nginx
      # kubernetes.io/tls-acme: "true"
    hosts:
      - host: chart-example.local
        paths:
          - path: /
            pathType: ImplementationSpecific
    tls: []
    #  - secretName: chart-example-tls
    #    hosts:
    #      - chart-example.local

  resources:
    {}
    # limits:
    #   cpu: "700m"
    #   memory: "550Mi"
    # requests:
    #   cpu: "350m"
    #   memory: "400Mi"

  autoscaling:
    enabled: false
    minReplicas: 1
    maxReplicas: 100
    targetCPUUtilizationPercentage: 80
    # targetMemoryUtilizationPercentage: 80

  nodeSelector: {}

  tolerations: []

  affinity: {}

agent:
  replicaCount: 1
  image:
    repository: jetbrains/teamcity-agent
    pullPolicy: IfNotPresent
    # Overrides the image tag whose default is the chart appVersion.
    tag: latest

  imagePullSecrets: []
  nameOverride: ""
  fullnameOverride: ""

  logging:
    enabled: true

  serviceAccount:
    # Specifies whether a service account should be created
    create: true
    # Annotations to add to the service account
    annotations: {}
    # The name of the service account to use.
    # If not set and create is true, a name is generated using the fullname template
    name: teamcity-agent

  podAnnotations: {}

  podSecurityContext: {}
  securityContext: {}

  resources:
    {}
    # limits:
    #   cpu: "700m"
    #   memory: "550Mi"
    # requests:
    #   cpu: "350m"
    #   memory: "400Mi"

  autoscaling:
    enabled: false
    minReplicas: 1
    maxReplicas: 100
    targetCPUUtilizationPercentage: 80
    # targetMemoryUtilizationPercentage: 80

  nodeSelector: {}

  tolerations: []

  affinity: {}

global:
  resource_quota:
    enabled: false
    cpu: "10000"
    memory: 10Gi
    pods: "10"
