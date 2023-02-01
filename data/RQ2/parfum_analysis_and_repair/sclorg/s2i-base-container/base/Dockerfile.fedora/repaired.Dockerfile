# This image is the base image for all OpenShift v3 language container images.
FROM quay.io/fedora/s2i-core:36

ENV SUMMARY="Base image with essential libraries and tools used as a base for \
builder images like perl, python, ruby, etc." \
    DESCRIPTION="The s2i-base image, being built upon s2i-core, provides any \
images layered on top of it with all the tools needed to use source-to-image \
functionality. Additionally, s2i-base also contains various libraries needed for \
it to serve as a base for other builder images, like s2i-python or s2i-ruby." \
    NAME=s2i-base \
    VERSION=1 \
    ARCH=x86_64

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="s2i base" \
      com.redhat.component="$NAME" \
      name="fedora/$NAME" \
      version="$VERSION" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

# This is the list of basic dependencies that all language container image can
# consume.