# Docker image that is capable of downloading an Agave file to the local system.
#
# image: eod_download

from alpine:3.2

RUN apk add --update musl python && rm /var/cache/apk/*
RUN apk add --update musl py-pip && rm /var/cache/apk/*

RUN apk add --update bash && rm -f /var/cache/apk/*
RUN apk add --update git && rm -f /var/cache/apk/*

ADD agave/eod_download/requirements.txt /eod_download/requirements.txt
RUN pip install --no-cache-dir -r /eod_download/requirements.txt
ADD endofday.conf /endofday.conf

ADD core /core
ADD agave/eod_download /eod_download


CMD ["python", "/eod_download/download.py"]
