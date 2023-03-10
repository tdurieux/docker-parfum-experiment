# STEP 1
# Get builded openzwave
# http://old.openzwave.com/downloads/
FROM chrisns/openzwave:alpine-1.6.1714 as ozw

# STEP 2
# Prepare server package*.json files
FROM node:14-alpine as json-files
COPY ./server /json-files/server
WORKDIR /json-files/server/
RUN find . -type f \! -name "package*.json" -exec rm -r {} \;
COPY ./server/cli /json-files/server/cli
COPY ./server/utils /json-files/server/utils


# STEP 3
# Gladys Bundle
FROM node:14-alpine as gladys

# System dependencies
RUN apk add --no-cache \
         tzdata \
         nmap \
         ffmpeg \
         sqlite \
         openssl \
         gzip \
         eudev \
         bluez

COPY --from=ozw /usr/local/include/openzwave /usr/local/include/openzwave
COPY --from=ozw /openzwave/libopenzwave.so* /lib/
COPY --from=ozw /openzwave/config /usr/local/etc/openzwave
COPY --from=json-files /json-files/server /src/server

ENV LD_LIBRARY_PATH /lib

WORKDIR /src/server

RUN apk add --no-cache --virtual .build-deps make gcc g++ python3 git libffi-dev linux-headers \
    && ln -s /usr/bin/python3 /usr/bin/python && ln -s /usr/bin/pip3 /usr/bin/pip \
    && npm ci --unsafe-perm --production \
    && npm cache clean --force \
    && apk del .build-deps

# Copy builded front
COPY ./static /src/server/static
# Copy codebase
COPY . /src

ENV NODE_ENV production
ENV SERVER_PORT 80

# Export listening port