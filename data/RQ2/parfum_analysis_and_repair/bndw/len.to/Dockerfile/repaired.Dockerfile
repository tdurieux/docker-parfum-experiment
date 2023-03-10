# Copyright 2022 Ben Woodward. All rights reserved.
# Use of this source code is governed by a GPL style
# license that can be found in the LICENSE file.
# Build stage
FROM debian:buster-slim as build
ARG HUGO_VERSION=0.79.1

RUN apt-get update \
  && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN cd /usr/local/bin \
  && curl -f -L "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" \
  | tar xz \
  && hugo version

WORKDIR /build
COPY . .
RUN hugo
RUN find ./public -type f -name "*.html" > /tmp/html

# Validation stage
FROM ghcr.io/validator/validator:latest as validator
COPY --from=build /bin/cat /bin/cat
COPY --from=build /build/public /build/public
COPY --from=build /tmp/html /tmp/html
RUN vnu-runtime-image/bin/vnu --verbose --errors-only $(cat /tmp/html)

# Execution stage
FROM nginx:stable-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /build/public /usr/share/nginx/html
