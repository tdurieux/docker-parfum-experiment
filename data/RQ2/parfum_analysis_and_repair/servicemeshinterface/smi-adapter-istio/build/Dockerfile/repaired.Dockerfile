FROM registry.access.redhat.com/ubi7-dev-preview/ubi-minimal:7.6

ENV OPERATOR=/usr/local/bin/smi-adapter-istio \
    USER_UID=1001 \
    USER_NAME=smi-adapter-istio

# install operator binary
COPY build/_output/bin/smi-adapter-istio ${OPERATOR}

COPY build/bin /usr/local/bin
RUN  /usr/local/bin/user_setup

ENTRYPOINT ["/usr/local/bin/entrypoint"]

USER ${USER_UID}