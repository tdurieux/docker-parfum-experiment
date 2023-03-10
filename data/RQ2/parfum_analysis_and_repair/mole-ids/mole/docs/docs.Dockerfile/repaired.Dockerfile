FROM alpine:3.10

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin

COPY requirements.txt /mkdocs/
WORKDIR /mkdocs
VOLUME /mkdocs

RUN apk --no-cache --no-progress add musl-dev gcc python3-dev py3-pip \
  && pip3 install --no-cache-dir --user -r requirements.txt
