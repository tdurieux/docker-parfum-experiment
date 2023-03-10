FROM alpine:3.4

MAINTAINER Bastien Cadiot <bastien.cadiot@gmail.com>

ENV CONSUL_TEMPLATE_VERSION=0.18.3

RUN apk update && \
    apk add --no-cache libnl3 bash nginx zip && \
    rm -rf /var/cache/apk/*

ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /

RUN unzip /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip  && \
    mv /consul-template /usr/local/bin/consul-template && \
    rm -rf /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip

RUN mkdir -p /app/consul-template/template
ADD template/ /app/consul-template/template/
ADD template/lib /var/lib/nginx/html/lib

ADD entrypoint.sh /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]
