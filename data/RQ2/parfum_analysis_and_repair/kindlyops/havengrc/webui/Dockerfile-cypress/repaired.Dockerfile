FROM        cypress/included:3.4.0
MAINTAINER  Kindly Ops, LLC <support@kindlyops.com>


RUN addgroup --system havenuser && adduser --system --ingroup havenuser havenuser

RUN apt-get update && apt-get install --no-install-recommends -y \
    libcap2-bin \
 && rm -rf /var/ && rm -rf /var/lib/apt/lists/*;

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN mkdir /opt/config
COPY vendor/linux/caddy /opt
COPY cypress/Caddyfile.tmpl /opt/
COPY cypress/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chown -R havenuser:havenuser /opt && chgrp -R 0 /opt && chmod -R g=u /opt
RUN setcap CAP_NET_BIND_SERVICE=+eip /opt/caddy
# set up nsswitch.conf for Go's "netgo" implementation
# - https://github.com/golang/go/blob/go1.9.1/src/net/conf.go#L194-L275
RUN echo 'hosts: files dns' > /etc/nsswitch.conf

# USER havenuser

WORKDIR     /e2e
ADD . /e2e
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]