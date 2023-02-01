FROM alpine

# RUN apk --no-cache add curl
# That will install curl running first apk update and
# then rm -rf /var/cache/apk/*

RUN apk add --no-cache python \
    python-dev \
    py-pip \
    build-base \
    openjdk8-jre \
    perl  \
    curl  \
    nano  \
    php5   \
    ruby   \
    apache2 \
    nginx  \
    wget \
    nodejs

RUN pip install --no-cache-dir gunicorn