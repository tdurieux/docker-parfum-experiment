FROM python:3.7-alpine

LABEL maintainer="Samuel Gratzl <sam@sgratzl.com>"

VOLUME ["/backup"]
WORKDIR /backup
ENTRYPOINT ["/bin/bash"]

RUN apk add --update bash && rm -rf /var/cache/apk/*
# for better layers
RUN pip install --no-cache-dir slacker colorama

ADD . /data
RUN pip install --no-cache-dir -r /data/requirements.txt
RUN pip install --no-cache-dir /data
