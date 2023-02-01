FROM nginx:1.21.6

MAINTAINER Conjur Inc

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install --no-install-recommends -y iputils-ping procps openssl && rm -rf /var/lib/apt/lists/*;

WORKDIR /etc/nginx/

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/C=IL/ST=Israel/L=TLV/O=Onyx/CN=conjur-proxy-nginx" \
    -keyout cert.key -out cert.crt

COPY /test-proxy/default.conf /etc/nginx/conf.d/default.conf

