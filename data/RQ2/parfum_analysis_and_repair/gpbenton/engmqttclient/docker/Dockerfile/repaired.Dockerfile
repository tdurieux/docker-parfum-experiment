# Base image is gcc build env

FROM gcc:8.3.0 as builder

# log4c

WORKDIR /opt/energenie_mqtt_client/log4c
RUN curl -f -SL https://prdownloads.sourceforge.net/log4c/log4c-1.2.4.tar.gz \
    | tar -xzC . \
    && cd log4c-1.2.4 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make && make install \
    && rm -rf /opt/energenie_mqtt_client/log4c

# bcm2835

WORKDIR /opt/energenie_mqtt_client/bcm2835
RUN curl -f -SL https://www.airspayce.com/mikem/bcm2835/bcm2835-1.64.tar.gz \
    | tar -xzC . \
    && cd bcm2835-1.64 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make && make install \
    && rm -rf /opt/energenie_mqtt_client/bcm2835

# Setup mosquitto repo
# http://repo.mosquitto.org/debian/mosquitto-jessie.list
# http://repo.mosquitto.org/debian/mosquitto-stretch.list
# http://repo.mosquitto.org/debian/mosquitto-buster.list
WORKDIR /opt/energenie_mqtt_client/mosquitto
RUN curl -f -SL https://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add - \
    && curl -f -SL https://repo.mosquitto.org/debian/mosquitto-buster.list -o /etc/apt/sources.list.d/mosquitto.list \
    && apt-get update && apt-get install --no-install-recommends -y mosquitto-dev \
    && rm -rf /opt/energenie_mqtt_client/mosquitto && rm -rf /var/lib/apt/lists/*;

# MQTT client
WORKDIR /opt/energenie_mqtt_client
RUN git clone https://github.com/gpbenton/engMQTTClient.git \
    && cd engMQTTClient \
    && make


#Run stage
FROM debian:buster-slim

RUN apt-get update && apt-get install --no-install-recommends -y curl gnupg libexpat1 && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/energenie_mqtt_client/mosquitto
RUN curl -f -SL https://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add - \
    && curl -f -SL https://repo.mosquitto.org/debian/mosquitto-buster.list -o /etc/apt/sources.list.d/mosquitto.list \
    && apt-get update && apt-get install --no-install-recommends -y libmosquitto1 \
    && rm -rf /opt/energenie_mqtt_client/mosquitto && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /opt/energenie_mqtt_client/engMQTTClient/engMQTTClient /usr/local/bin

COPY --from=builder /usr/local/lib/liblog4c* /usr/local/lib/
COPY --from=builder /usr/local/include/log4c.h /usr/local/include/
COPY --from=builder /usr/local/include/log4c /usr/local/include/log4c/
COPY --from=builder /usr/local/bin/log4c-config /usr/local/bin/

COPY --from=builder /usr/local/lib/libbcm2835.a /usr/local/lib
COPY --from=builder /usr/local/include/bcm2835.h /usr/local/include

# FINISHED
ENV LD_LIBRARY_PATH /usr/local/lib
ENTRYPOINT ["/usr/local/bin/engMQTTClient"]
