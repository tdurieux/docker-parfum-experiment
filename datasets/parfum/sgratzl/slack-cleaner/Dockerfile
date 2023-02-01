FROM python:3.7-alpine

LABEL maintainer="Samuel Gratzl <sam@sgratzl.com>"

VOLUME ["/backup"]
WORKDIR /backup
ENTRYPOINT ["/bin/bash"]

RUN apk add --update bash && rm -rf /var/cache/apk/*
# for better layers
RUN pip install slacker colorama

ADD . /data
RUN pip install -r /data/requirements.txt
RUN pip install /data
