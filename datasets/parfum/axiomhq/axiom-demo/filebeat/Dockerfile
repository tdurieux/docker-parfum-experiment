# https://www.elastic.co/guide/en/beats/filebeat/current/running-on-docker.html#_custom_image_configuration
FROM docker.elastic.co/beats/filebeat-oss:7.10.2
COPY filebeat.yml /usr/share/filebeat/filebeat.yml
USER root
RUN chown root:filebeat /usr/share/filebeat/filebeat.yml && \
    chmod go-w /usr/share/filebeat/filebeat.yml
USER filebeat
