FROM arm64v8/eclipse-mosquitto:1.6.12

ARG MQTT_PORT=1883
ARG WS_PORT=9001

RUN mkdir -p /mosquitto/templates

# Overwrite the current configuration with the given one
COPY ./templates/mosquitto.mustache /mosquitto/templates

WORKDIR /mosquitto

COPY ./run.sh .
RUN chmod +x ./run.sh

# Install mustach binaries
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && apk update && apk add --no-cache mustach

EXPOSE ${MQTT_PORT}
EXPOSE ${WS_PORT}

ENTRYPOINT [ "/mosquitto/run.sh" ]