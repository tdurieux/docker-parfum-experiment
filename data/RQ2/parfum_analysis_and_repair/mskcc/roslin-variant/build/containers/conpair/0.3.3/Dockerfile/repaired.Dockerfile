FROM alpine:3.10

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.conpair="0.3.3" \
      version.alpine="3.10" \
      version.gatk="3.3-0" \
      source.gatk="https://software.broadinstitute.org/gatk/download/auth?package=GATK-archive&version=3.3-0-g37228af" \
      source.conpair="https://github.com/mskcc/Conpair/releases/tag/0.3.1" \
      source.r="https://pkgs.alpinelinux.org/package/edge/community/x86/R"

ENV CONPAIR_VERSION 0.3.3
ENV GATK_VERSION 3.3-0
ENV GATK_DOWNLOAD_URL https://s3.us-east-2.amazonaws.com/roslindata/gatk-3.3-0.jar

COPY install-packages.R /tmp/install-packages.R
COPY runscript.sh /usr/bin/runscript.sh
COPY run_test.sh /run_test.sh

RUN apk add --no-cache --update \
    # for wget
    && apk add --no-cache ca-certificates openssl \
    && wget ${GATK_DOWNLOAD_URL} -O /usr/bin/gatk.jar \
    # for compilation
    && apk add --no-cache build-base musl-dev python py-pip python-dev py-setuptools \
    && cd /tmp \
        # install R
        && apk add --no-cache R R-dev \
        # install R dependencies
        && R -e "install.packages(c('ggplot2', 'reshape2'), repos='http://cran.wustl.edu')" \
        # install numpy and scipy
        && pip install --no-cache-dir numpy==1.15.4 \
        && pip install --no-cache-dir scipy==1.1.0 \
        # install java
        && apk add --no-cache openjdk8-jre-base \
         # download and unzip conpair
        && cd /tmp && wget https://github.com/mskcc/Conpair/archive/${CONPAIR_VERSION}.tar.gz \
        && tar xvzf ${CONPAIR_VERSION}.tar.gz \
        # install conpair
        && mv /tmp/Conpair-${CONPAIR_VERSION} /usr/bin/conpair \
        # clean up
        && rm -rf /tmp/* \
        && chmod +x /usr/bin/runscript.sh \
        && exec /run_test.sh && rm ${CONPAIR_VERSION}.tar.gz

ENV LANG "C.UTF-8"
ENV PYTHONNOUSERSITE set
