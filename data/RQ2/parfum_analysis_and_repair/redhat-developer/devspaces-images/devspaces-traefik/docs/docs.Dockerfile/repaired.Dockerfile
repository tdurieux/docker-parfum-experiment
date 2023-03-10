FROM alpine:3.13

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin

COPY requirements.txt /mkdocs/
WORKDIR /mkdocs
VOLUME /mkdocs

RUN apk --no-cache --no-progress add py3-pip gcc musl-dev python3-dev \
  && pip3 install --no-cache-dir --user -r requirements.txt
