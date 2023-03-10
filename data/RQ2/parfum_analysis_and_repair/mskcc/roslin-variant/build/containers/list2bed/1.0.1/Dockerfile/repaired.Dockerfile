FROM alpine:3.8

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.list2bed="1.0.1" \
      version.alpine="3.8" \
      source.list2bed="https://github.com/mskcc/list2bed/releases/tag/1.0.1"

ENV LIST2BED_VERSION 1.0.1
COPY runscript.sh /usr/bin/runscript.sh
COPY run_test.sh /run_test.sh

RUN apk add --update \
      # for wget
            && apk add ca-certificates openssl \
      # for compilation (pybedtools)
            && apk add build-base musl-dev zlib-dev bzip2-dev xz-dev cython cython-dev python py-pip python-dev\
      # install pybedtools \
            && pip install --no-cache-dir pybedtools \
      # download, unzip list2bed
            && cd /tmp && wget https://github.com/mskcc/list2bed/archive/${LIST2BED_VERSION}.zip \
            && unzip ${LIST2BED_VERSION}.zip \
      # copy to /usr/bin
            && mv /tmp/list2bed-${LIST2BED_VERSION}/list2bed.py /usr/bin/ \
      # clean up
            && rm -rf /var/cache/apk/* /tmp/* \
            && chmod +x /usr/bin/runscript.sh \
            && exec /run_test.sh

# disable per-user site-packages before run
ENV PYTHONNOUSERSITE set