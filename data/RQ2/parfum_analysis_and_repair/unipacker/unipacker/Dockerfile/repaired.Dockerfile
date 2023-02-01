FROM alpine:3.13.2

WORKDIR /app
RUN apk update
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing yara
RUN apk add --no-cache python2 python3 python3-dev build-base linux-headers
RUN python3 -m ensurepip && pip3 install --no-cache-dir --upgrade pip wheel
RUN pip3 install --no-cache-dir unipacker

ENTRYPOINT [ "unipacker" ]
