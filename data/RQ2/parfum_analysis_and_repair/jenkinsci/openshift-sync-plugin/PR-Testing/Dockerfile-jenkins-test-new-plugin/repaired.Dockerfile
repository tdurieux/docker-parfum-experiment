FROM quay.io/openshift/origin-jenkins:latest
USER root
COPY download-dependencies.sh /usr/local/bin
COPY ./jpi /opt/openshift/plugins
RUN /usr/local/bin/download-dependencies.sh