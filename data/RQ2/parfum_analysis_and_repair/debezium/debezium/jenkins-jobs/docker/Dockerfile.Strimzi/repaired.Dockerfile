ARG FROM_IMAGE
FROM ${FROM_IMAGE}

USER root:root
ADD ./plugins/ /opt/kafka/plugins/

USER 1001