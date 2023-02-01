FROM alpine:3.8

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.picard="2.9" \
      version.alpine="3.8" \
      version.r="3.5.1" \
      source.picard="https://github.com/broadinstitute/picard/releases/tag/2.9.0" \
      source.r="https://pkgs.alpinelinux.org/package/edge/community/x86/R"

ENV TOOL_VERSION 2.9.0
COPY runscript.sh /usr/bin/runscript.sh
COPY run_test.sh /run_test.sh

RUN apk add --no-cache --update \
      && apk add --no-cache ca-certificates openssl \
      && apk add --no-cache openjdk8-jre-base \
      && apk add --no-cache R R-dev \
      && cd /tmp && wget https://github.com/broadinstitute/picard/releases/download/${TOOL_VERSION}/picard.jar \
      && mkdir /usr/bin/picard-tools/ \
      && mv /tmp/picard.jar /usr/bin/picard-tools/picard.jar \
      && rm -rf /var/cache/apk/* /tmp/* \
      && chmod +x /usr/bin/runscript.sh \
      && exec /run_test.sh
