FROM alpine:3.12

# Set Helm version
ENV DESIRED_VERSION=v3.8.2

RUN apk add --no-cache --update bash ca-certificates openssl curl git \
    && ( curl -f https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash) \
    && helm version

COPY package.sh /usr/sbin/
