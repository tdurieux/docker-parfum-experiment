# Build the manager binary
FROM quay.io/operator-framework/helm-operator:v1.9.0
LABEL name="JFrog Xray Enterprise Operator" \
      description="Openshift operator to deploy JFrog Xray Enterprise based on the Red Hat Universal Base Image" \
      vendor="JFrog" \
      summary="JFrog Xray Enterprise Operator" \
      com.jfrog.license_terms="https://jfrog.com/xray/eula/"

# Adding security checks for container vulnerability scan