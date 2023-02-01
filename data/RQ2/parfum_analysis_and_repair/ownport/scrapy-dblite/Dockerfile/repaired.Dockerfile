FROM alpine:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apk add --no-cache --update \
		make \
        python \
        py-pip

RUN pip install --no-cache-dir nose coverage

RUN mkdir -p /data/bin
RUN mkdir -p /data/scrapy-dblite

ADD scripts/run-as.sh /data/bin/
RUN chmod +x /data/bin/*.sh
