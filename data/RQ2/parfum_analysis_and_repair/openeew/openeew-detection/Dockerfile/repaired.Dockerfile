FROM alpine:3.12.0

RUN apk update --no-cache \
  && apk add --no-cache mosquitto python3 py3-pip py3-paho-mqtt py3-numpy py3-psycopg2 bash logrotate \
  && /usr/bin/pip3 install tweepy \
  && mkdir /opt/openeew/ \
  && touch /opt/openeew/mosquitto.conf \
  && mkdir /var/log/mosquitto \
  && chown mosquitto:mosquitto /var/log/mosquitto \
  && echo "log_dest file /var/log/mosquitto/mosquitto.log" >> /opt/openeew/mosquitto.conf \
  && apk del bash \
  && rm -rf /var/cache/apk/*

COPY openeew/*.py /opt/openeew/
COPY detector /usr/sbin/detector
COPY logrotate/mosquitto /etc/logrotate.d/

USER root
CMD ["/usr/sbin/detector"]