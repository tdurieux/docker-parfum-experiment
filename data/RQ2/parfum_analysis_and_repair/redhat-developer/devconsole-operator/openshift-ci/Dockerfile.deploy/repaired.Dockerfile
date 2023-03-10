FROM registry.access.redhat.com/ubi7-dev-preview/ubi-minimal:latest
LABEL com.redhat.delivery.appregistry=true

LABEL maintainer "Devtools <devtools@redhat.com>"
LABEL author "Devtools <devtools@redhat.com>"

ENV LANG=en_US.utf8

COPY operator /usr/local/bin/devconsole-operator
USER 10001

ENTRYPOINT [ "/usr/local/bin/devconsole-operator" ]