FROM alpine:3.6

RUN DEV_PACKAGES="python-dev gcc make musl-dev openssl-dev libffi-dev" \
 && apk add --no-cache bash python openssl libffi netcat-openbsd py-pip $DEV_PACKAGES \
 && pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir cffi \
 && pip install --no-cache-dir ansible==2.3.1.0 \
 && apk del $DEV_PACKAGES
