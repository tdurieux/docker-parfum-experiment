FROM splunk/splunk:latest

USER root

ENV SPLUNK_START_ARGS="--accept-license --no-prompt"
ENV SPLUNK_USER=root
ENV SPLUNK_GROUP=root
ENV SPLUNK_HOME=/opt/splunk

EXPOSE 8000
EXPOSE 9997