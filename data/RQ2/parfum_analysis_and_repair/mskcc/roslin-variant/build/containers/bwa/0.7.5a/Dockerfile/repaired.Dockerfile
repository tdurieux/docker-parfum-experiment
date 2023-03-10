FROM alpine:3.8

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.bwa="0.7.5a" \
      version.alpine="3.8" \
      version.samtools="1.9" \
      source.bwa="https://github.com/lh3/bwa/releases/tag/0.7.5a" \
      source.samtools="https://github.com/samtools/samtools/releases/tag/1.9"

ENV BWA_VERSION 0.7.5a
ENV SAM_TOOLS_VERSION 1.9
COPY runscript.sh /usr/bin/runscript.sh
COPY run_test.sh /run_test.sh

RUN apk add --update \
      # install build tools and dependencies
            && apk add --virtual=deps --update --no-cache build-base ncurses-dev musl-dev bzip2-dev xz-dev zlib-dev \
      # install openssl and certificates for wget
            && apk add ca-certificates openssl \
      # install samtools
            && cd /tmp && wget https://github.com/samtools/samtools/releases/download/${SAM_TOOLS_VERSION}/samtools-${SAM_TOOLS_VERSION}.tar.bz2 \
            && cd /tmp/ && tar xjvf samtools-${SAM_TOOLS_VERSION}.tar.bz2 \
            && cd /tmp/samtools-${SAM_TOOLS_VERSION} && make \
            && mv /tmp/samtools-${SAM_TOOLS_VERSION}/samtools /usr/bin \
      # download and unzip bwa
            && cd /tmp && wget https://github.com/lh3/bwa/archive/${BWA_VERSION}.zip \
            && unzip ${BWA_VERSION}.zip \
      # alpine-specific data types
            && cd /tmp/bwa-${BWA_VERSION} \
            && sed -i[.bak] "s/u_int32_t/uint32_t/g" *.c \
            && sed -i[.bak] "s/u_int32_t/uint32_t/g" *.h \
      # build
            && make \
      # move binaries to /usr/bin
            && mv /tmp/bwa-${BWA_VERSION}/bwa /usr/bin \
      # clean up
            && rm -rf /var/cache/apk/* /tmp/* \
            && apk del deps \
            && chmod +x /usr/bin/runscript.sh \
            && exec /run_test.sh && rm samtools-${SAM_TOOLS_VERSION}.tar.bz2