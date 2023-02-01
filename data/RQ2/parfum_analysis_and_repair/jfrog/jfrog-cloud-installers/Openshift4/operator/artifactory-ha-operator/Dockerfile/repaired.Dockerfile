# Build the manager binary

FROM quay.io/operator-framework/helm-operator:v1.9.0
LABEL name="JFrog Artifactory Enterprise Operator" \
      description="Openshift operator to deploy JFrog Artifactory Enterprise based on the Red Hat Universal Base Image." \
      vendor="JFrog" \
      summary="JFrog Artifactory Enterprise Operator" \
      com.jfrog.license_terms="https://jfrog.com/artifactory/eula/"

# Adding security checks for container vulnerability scan