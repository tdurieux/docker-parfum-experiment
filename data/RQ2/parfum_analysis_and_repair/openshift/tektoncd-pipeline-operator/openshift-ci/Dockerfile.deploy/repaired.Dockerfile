FROM registry.redhat.io/ubi8/ubi-minimal:latest

LABEL com.redhat.delivery.appregistry=true
LABEL maintainer "pipelines-dev <pipelines-dev@redhat.com>"
LABEL author "pipelines-dev <pipelines-dev@redhat.com>"

ENV OPERATOR=/usr/local/bin/openshift-pipelines-operator \
    USER_UID=1001 \
    USER_NAME=openshift-pipelines-operator

ENV LANG=en_US.utf8

# install operator binary
COPY operator ${OPERATOR}

COPY build/bin /usr/local/bin
RUN  /usr/local/bin/user_setup

COPY deploy/resources /deploy/resources

# UBI8 image missing uuidgen
RUN cat /proc/sys/kernel/random/uuid > /deploy/uuid

ENTRYPOINT ["/usr/local/bin/entrypoint"]

USER ${USER_UID}