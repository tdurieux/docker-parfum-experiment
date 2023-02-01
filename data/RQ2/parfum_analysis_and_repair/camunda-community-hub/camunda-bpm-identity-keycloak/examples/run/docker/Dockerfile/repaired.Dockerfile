# Get Camunda-run as base image
FROM camunda/camunda-bpm-platform:run-7.17.0

# The Version of the Keycloak Identity Provider to use
ENV IDENTITY_PROVIDER_VERSION=7.17.0

# Add Keycloak Identity Provider