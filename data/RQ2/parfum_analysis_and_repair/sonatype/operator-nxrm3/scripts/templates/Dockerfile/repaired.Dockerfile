# {{templateWarning}}
FROM quay.io/operator-framework/helm-operator:v1.21.0

# Required OpenShift Labels
LABEL name="Nexus Repository Operator" \
      vendor="Sonatype" \
      version="{{shortVersion}}" \
      release="1" \
      summary="The Nexus Repository Manager with universal support for popular component formats." \
      description="The Nexus Repository Manager with universal support for popular component formats."

# Required Licenses