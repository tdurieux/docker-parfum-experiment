FROM registry.access.redhat.com/ubi9-minimal

LABEL org.opencontainers.image.source="https://github.com/drogue-iot/drogue-cloud"

ADD target/release/drogue-cloud-topic-admin-operator /

ENTRYPOINT [ "/drogue-cloud-topic-admin-operator" ]