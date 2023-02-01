FROM registry.access.redhat.com/ubi8/ubi-minimal:8.1
ARG GIT_VERSION=unknown
LABEL name="Calico Operator" \
      vendor="Project Calico" \
      version=$GIT_VERSION \
      release="1" \
      summary="Calico Operator manages the lifecycle of a Calico or Tigera Secure installation on Kubernetes or OpenShift" \
      description="Calico Operator manages the lifecycle of a Calico or Tigera Secure installation on Kubernetes or OpenShift" \
      maintainer="Laurence Man <laurence@tigera.io>"

# Add in top-level license file
RUN mkdir /licenses
COPY LICENSE /licenses

ENV OPERATOR=/usr/local/bin/operator \
    USER_UID=1001 \
    USER_NAME=operator

# install operator binary
COPY build/_output/bin/operator-s390x ${OPERATOR}

COPY build/bin /usr/local/bin
RUN  /usr/local/bin/user_setup

ENTRYPOINT ["/usr/local/bin/entrypoint"]

USER ${USER_UID}