FROM arm32v6/alpine:latest

RUN apk update \
    && apk add --no-cache bash mosquitto mosquitto-clients \
    && rm -fr /tmp/*

# Install kafkacat to publish msgs to IBM Message Hub
COPY key/*.rsa.pub /etc/apk/keys/
COPY key/kafkacat-*.apk /
RUN apk --no-cache add /kafkacat-*.apk && rm kafkacat-*.apk

COPY mqtt_receive.sh /
WORKDIR /
RUN ["chmod", "+x", "./mqtt_receive.sh"]
CMD ["./mqtt_receive.sh"]