FROM python:3-alpine

MAINTAINER Jookies LTD <jasmin@jookies.net>

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN addgroup -S jasmin && adduser -S -g jasmin jasmin

# Install requirements
RUN apk --update --no-cache add \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    python3-dev \
    py3-pip \
    git \
    bash

WORKDIR /build

ENV ROOT_PATH /
ENV CONFIG_PATH /etc/jasmin
ENV RESOURCE_PATH /etc/jasmin/resource
ENV STORE_PATH /etc/jasmin/store
ENV LOG_PATH /var/log/jasmin

RUN mkdir -p ${CONFIG_PATH} ${RESOURCE_PATH} ${STORE_PATH} ${LOG_PATH}
RUN chown jasmin:jasmin ${CONFIG_PATH} ${RESOURCE_PATH} ${STORE_PATH} ${LOG_PATH}

WORKDIR /build

RUN pip install --no-cache-dir -e git+https://github.com/jookies/txamqp.git@master#egg=txamqp3
RUN pip install --no-cache-dir -e git+https://github.com/jookies/python-messaging.git@master#egg=python-messaging
RUN pip install --no-cache-dir -e git+https://github.com/jookies/smpp.pdu.git@master#egg=smpp.pdu3
RUN pip install --no-cache-dir -e git+https://github.com/jookies/smpp.twisted.git@master#egg=smpp.twisted3

COPY . .

RUN pip install --no-cache-dir .

COPY misc/config/*.cfg ${CONFIG_PATH}
COPY misc/config/resource/*.xml ${RESOURCE_PATH}

ENV UNICODEMAP_JP unicode-ascii

WORKDIR /usr/jasmin

# Change binding host for jcli, redis, and amqp
RUN sed -i '/\[jcli\]/a bind=0.0.0.0' ${CONFIG_PATH}/jasmin.cfg
RUN sed -i '/\[redis-client\]/a host=redis' ${CONFIG_PATH}/jasmin.cfg
RUN sed -i '/\[amqp-broker\]/a host=rabbitmq' ${CONFIG_PATH}/jasmin.cfg

EXPOSE 2775 8990 1401
VOLUME [${LOG_PATH}, ${CONFIG_PATH}, ${STORE_PATH}]

COPY docker/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["jasmind.py", "--enable-interceptor-client", "--enable-dlr-thrower", "--enable-dlr-lookup", "-u", "jcliadmin", "-p", "jclipwd"]
# Notes:
# - jasmind is started with native dlr-thrower and dlr-lookup threads instead of standalone processes
# - restapi (0.9rc16+) is not started in this docker configuration
