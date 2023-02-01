#
# This is the integrated OpenShift Origin Docker registry. It is configured to
# publish metadata to OpenShift to provide automatic management of images on push.
#
# The standard name for this image is openshift/origin-docker-registry
#
FROM openshift/origin-base

COPY config.yml $REGISTRY_CONFIGURATION_PATH
COPY bin/dockerregistry /dockerregistry

LABEL io.k8s.display-name="OpenShift Origin Image Registry" \
      io.k8s.description="This is a component of OpenShift Origin and exposes a Docker registry that is integrated with the cluster for authentication and management."

# The registry doesn't require a root user.