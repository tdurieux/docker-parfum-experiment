FROM alpine:3.8

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.replaceallelcounts="0.2.0" \
      version.alpine="3.8" \
      source.replaceallelecounts="https://github.com/mskcc/replace_allele_counts/releases/tag/0.2.0"

ENV REPLACEALLELECOUNTS_VERSION 0.2.0

RUN apk add --update \
      # for wget
            && apk add ca-certificates openssl \
      # for compilation (numpy, ...)
            && apk add build-base musl-dev python py-pip python-dev\
      # download, unzip, install
            && cd /tmp && wget https://github.com/mskcc/replace_allele_counts/archive/${REPLACEALLELECOUNTS_VERSION}.zip \
            && unzip ${REPLACEALLELECOUNTS_VERSION}.zip \
            && cd /tmp/replace_allele_counts-${REPLACEALLELECOUNTS_VERSION} \
            && python setup.py install \
      # copy to /usr/bin
            && cp /tmp/replace_allele_counts-${REPLACEALLELECOUNTS_VERSION}/replace_allele_counts.py /usr/bin/ \
      # clean up
            && rm -rf /var/cache/apk/* /tmp/*

# disable per-user site-packages before run
ENV PYTHONNOUSERSITE set

ENTRYPOINT ["python", "/usr/bin/replace_allele_counts.py"]
CMD ["--help"]
