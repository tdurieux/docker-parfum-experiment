FROM python:3-buster

MAINTAINER Jookies LTD <jasmin@jookies.net>

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r jasmin && useradd -r -g jasmin jasmin

# Install requirements
RUN apt-get update && apt-get install --no-install-recommends -y \
    libffi-dev \
    libssl-dev \
    rabbitmq-server \
    redis-server \
    supervisor \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Jasmin SMS gateway
RUN mkdir -p /etc/jasmin/resource \
    /etc/jasmin/store \
    /var/log/jasmin \
  && chown jasmin:jasmin /etc/jasmin/store \
    /var/log/jasmin

WORKDIR /usr/jasmin

COPY jasmin jasmin
COPY requirements.txt .
COPY requirements-test.txt .
COPY setup.py .
COPY README.rst .

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements-test.txt
RUN pip install --no-cache-dir -e git+https://github.com/jookies/python-messaging.git@master#egg=python-messaging
RUN pip install --no-cache-dir -e git+https://github.com/jookies/smpp.pdu.git@master#egg=smpp.pdu3
RUN pip install --no-cache-dir -e git+https://github.com/jookies/smpp.twisted.git@master#egg=smpp.twisted3
RUN pip install --no-cache-dir .

ENV UNICODEMAP_JP unicode-ascii

ENV ROOT_PATH /
ENV CONFIG_PATH /etc/jasmin
ENV RESOURCE_PATH /etc/jasmin/resource
ENV STORE_PATH /etc/jasmin/store
ENV LOG_PATH /var/log/jasmin

COPY misc/config/*.cfg ${CONFIG_PATH}/
COPY misc/config/resource ${RESOURCE_PATH}

# Change binding host for jcli
RUN sed -i '/\[jcli\]/a bind=0.0.0.0' ${CONFIG_PATH}/jasmin.cfg

COPY docker/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["jasmind.py", "--enable-interceptor-client", "--enable-dlr-thrower", "--enable-dlr-lookup", "-u", "jcliadmin", "-p", "jclipwd"]
# Notes:
# - jasmind is started with native dlr-thrower and dlr-lookup threads instead of standalone processes
# - restapi (0.9rc16+) is not started in this docker configuration
