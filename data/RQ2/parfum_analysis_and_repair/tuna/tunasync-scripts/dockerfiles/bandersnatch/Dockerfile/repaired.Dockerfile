FROM python:3.9-alpine

RUN apk add --update --no-cache --virtual .build-deps \
        g++ \
        bash \
        python3-dev \
        libxml2 \
        libxml2-dev && \
    apk add --no-cache libxslt-dev
RUN pip3 install --no-cache-dir bandersnatch
CMD /bin/bash
