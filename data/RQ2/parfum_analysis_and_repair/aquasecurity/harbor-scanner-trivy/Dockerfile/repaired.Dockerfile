# That's the only place where you're supposed to specify version of Trivy.
ARG TRIVY_VERSION=0.29.2

FROM aquasec/trivy:${TRIVY_VERSION}

# An ARG declared before a FROM is outside of a build stage, so it can't be used in any
# instruction after a FROM. To use the default value of an ARG declared before the first
# FROM use an ARG instruction without a value inside of a build stage.