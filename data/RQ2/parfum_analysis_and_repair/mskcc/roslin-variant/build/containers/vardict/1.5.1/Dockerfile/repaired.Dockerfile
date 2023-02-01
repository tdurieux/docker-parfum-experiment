FROM alpine:3.8

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.vardict="1.5.1" \
      version.r="3.5.1" \
      version.perl="5.26.2-r1" \
      version.alpine="3.8" \
      source.vardict="https://github.com/AstraZeneca-NGS/VarDictJava/releases/tag/v1.5.1" \
      source.r="https://pkgs.alpinelinux.org/package/edge/community/x86/R" \
      source.perl="https://pkgs.alpinelinux.org/package/edge/main/aarch64/perl"

ENV VARDICT_VERSION 1.5.1

COPY runscript.sh /usr/bin/runscript.sh
COPY run_test.sh /run_test.sh

RUN apk add --no-cache --update \
      && apk add --no-cache ca-certificates openssl bash perl \
      && apk add --no-cache openjdk8-jre-base \
      && apk add --no-cache R R-dev \
      && cd /tmp && wget https://github.com/AstraZeneca-NGS/VarDictJava/releases/download/v${VARDICT_VERSION}/VarDict-${VARDICT_VERSION}.zip \
      && unzip VarDict-${VARDICT_VERSION}.zip \
      && mv /tmp/VarDict-${VARDICT_VERSION} /usr/bin/vardict \
      && rm -rf /var/cache/apk/* /tmp/* \
      && chmod +x /usr/bin/runscript.sh \
      && exec /run_test.sh

COPY testsomatic.R /usr/bin/vardict/
COPY var2vcf_paired.pl /usr/bin/vardict/