FROM docker:18.05

MAINTAINER Orestis Akrivopoulos

ENV LANG=C.UTF-8

RUN mkdir -p /opt/csplogs/

RUN apk add --no-cache --virtual=build-dependencies wget ca-certificates unzip && update-ca-certificates && update-ca-certificates && apk add --no-cache openjdk8 \
   && apk del build-dependencies && java -version

RUN apk add --no-cache bash drill wget ca-certificates libressl python py2-pip py-jinja2 git curl py-pip python-dev libffi-dev openssl-dev gcc  libc-dev  make \
   && pip install --no-cache-dir --upgrade pip \
   && pip install --no-cache-dir j2cli[yaml] cryptography==2.8 && update-ca-certificates
RUN pip install --no-cache-dir docker-compose


COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
