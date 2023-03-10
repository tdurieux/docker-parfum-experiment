FROM splunk/universalforwarder:latest

USER root

ENV SPLUNK_START_ARGS="--accept-license --no-prompt"
ENV SPLUNK_USER=root
ENV SPLUNK_GROUP=root
ENV SPLUNK_HOME=/opt/splunkforwarder

EXPOSE 9997

RUN mkdir /configmap
COPY uf-inputs.conf /configmap/inputs.conf
COPY uf-outputs.conf /configmap/outputs.conf

COPY run-uf.sh /run.sh

#ENTRYPOINT ["/run.sh"]