FROM registry.access.redhat.com/ubi7/ubi-minimal:latest

# The following labels are required for Redhat container certification
LABEL vendor="Kabanero" \
      name="Kabanero Operator" \
      summary="Image for Kabanero Operator" \
      description="This image contains the controller for the Kabanero Foundation.  See https://github.com/kabanero-io/kabanero-operator/"

# The license must be here for Redhat container certification
COPY LICENSE /licenses/

ENV OPERATOR=/usr/local/bin/kabanero-operator \
    USER_UID=1001 \
    USER_NAME=kabanero-operator

# install operator binary and supporting controllers.
COPY build/_output/bin/kabanero-operator ${OPERATOR}
COPY build/_output/bin/kabanero-operator-stack-controller /usr/local/bin/kabanero-operator-stack-controller
COPY build/_output/bin/admission-webhook /usr/local/bin/admission-webhook
COPY build/_output/bin/devfile-registry-controller /usr/local/bin/devfile-registry-controller

RUN mkdir /devfiles && chmod +777 /devfiles

COPY build/bin /usr/local/bin
RUN  /usr/local/bin/user_setup

# Note that the entrypoint will be over-ridden in the pod/deployment
# definitions for the supporting controllers, and admission webhook.
ENTRYPOINT ["/usr/local/bin/entrypoint"]

USER ${USER_UID}