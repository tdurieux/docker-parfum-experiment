FROM alpine:3.8
MAINTAINER Henning Jacobs <henning@jacobs1.de>

RUN apk add --no-cache python3 && \
    pip3 install pykube && \
    rm -rf /var/cache/apk/* /root/.cache /tmp/*

WORKDIR /

COPY cleaner.py /

ENTRYPOINT ["/cleaner.py"]
