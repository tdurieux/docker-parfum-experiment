FROM alpine:3.8

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.getBaseCountsMultiSample="1.2.2" \
      version.samtools="1.9" \
      version.htslib="1.9" \
      version.alpine="3.8" \
      version.picard="2.9" \
      version.cmo="1.9.15" \
      version.r="3.5.1" \
      source.picard="https://github.com/broadinstitute/picard/releases/tag/2.9.0" \
      source.r="https://pkgs.alpinelinux.org/package/edge/community/x86/R" \
      source.htslib="https://github.com/samtools/htslib/releases/tag/1.9" \
      source.samtools="https://github.com/samtools/samtools/releases/tag/1.9" \
      source.getBaseCountsMultiSample="https://github.com/zengzheng123/GetBaseCountsMultiSample/releases/tag/v1.2.2" \
      source.cmo="https://github.com/mskcc/cmo/releases/tag/1.9.15"


ENV GET_BASE_COUNTS_MULTI_SAMPLE_VERSION 1.2.2
ENV CMO_VERSION 1.9.15
ENV HTSLIB_VERSION 1.9
ENV SAMTOOLS_VERSION 1.9
ENV PICARD_VERSION 2.9.0

COPY runscript.sh /usr/bin/runscript.sh
COPY run_test.sh /run_test.sh
COPY cmo_resources.json /usr/bin/cmo_resources.json

RUN apk add --update \
      # install all the build-related tools
            && apk add coreutils bash cmake jsoncpp build-base musl-dev python py-pip python-dev ca-certificates openssl gcc g++ make git curl curl-dev wget gzip musl-dev libgcrypt-dev zlib-dev bzip2-dev xz-dev ncurses-dev subversion openjdk8-jre-base R R-dev \
      # install picard
            && cd /tmp && wget https://github.com/broadinstitute/picard/releases/download/${PICARD_VERSION}/picard.jar \
            && mkdir /usr/bin/picard-tools/ \
            && mv /tmp/picard.jar /usr/bin/picard-tools/picard.jar \
      # download and unzip gbcms
            && cd /tmp && wget https://github.com/zengzheng123/GetBaseCountsMultiSample/archive/v${GET_BASE_COUNTS_MULTI_SAMPLE_VERSION}.zip \
            && unzip v${GET_BASE_COUNTS_MULTI_SAMPLE_VERSION}.zip \
      # install htslib
            && cd /tmp && wget https://github.com/samtools/htslib/releases/download/${HTSLIB_VERSION}/htslib-${HTSLIB_VERSION}.tar.bz2 \
            && tar xvjf htslib-${HTSLIB_VERSION}.tar.bz2 \
            && cd /tmp/htslib-${HTSLIB_VERSION} \
            && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
            && make && make install \
      # install samtools
            && cd /tmp && wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 \
            && tar xvjf samtools-${SAMTOOLS_VERSION}.tar.bz2 \
            && cd /tmp/samtools-${SAMTOOLS_VERSION} \
            && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-htslib=/tmp/htslib-${HTSLIB_VERSION} \
            && make && make install \
      # build and install bamtools
            && cd /tmp/GetBaseCountsMultiSample-${GET_BASE_COUNTS_MULTI_SAMPLE_VERSION}/bamtools-master \
            && rm -r build/ \
            && mkdir build \
            && cd build/ \
            && cmake -DCMAKE_CXX_FLAGS=-std=c++03 .. \
            && make \
            && make install \
      # copy libbamtools to /usr/lib/
            && cp ../lib/libbamtools.so.2.3.0 /usr/lib/ \
      # install getBaseCountsMultiSample
            && cd /tmp/GetBaseCountsMultiSample-${GET_BASE_COUNTS_MULTI_SAMPLE_VERSION} \
            && make \
      # copy bins to /usr/lib/
            && cp GetBaseCountsMultiSample /usr/bin/ \
      # download, unzip, install cmo
            && cd /tmp && wget https://github.com/mskcc/cmo/archive/${CMO_VERSION}.zip \
            && unzip ${CMO_VERSION}.zip \
            && cd /tmp/cmo-${CMO_VERSION} \
            && sed -i "s/'CMO_RESOURCE_CONFIG'/None/g" cmo/util.py \
            && sed -i "s/\/opt\/common\/CentOS_6-dev\/cmo\/cmo_resources.json/\/usr\/bin\/cmo_resources.json/g" cmo/util.py \
            && python setup.py install \
      # clean up
            && rm -rf /var/cache/apk/* /tmp/* \
            && chmod +x /usr/bin/runscript.sh \
            && exec /run_test.sh && rm htslib-${HTSLIB_VERSION}.tar.bz2
# disable per-user site-packages before run
ENV PYTHONNOUSERSITE set