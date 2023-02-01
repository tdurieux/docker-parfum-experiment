FROM alpine:edge
MAINTAINER rubik

WORKDIR /usr/src/app
COPY . /usr/src/app

RUN apk --update add \
  python2 python3 py2-pip && \
  pip2 install --no-cache-dir --upgrade pip && \
  pip2 install --no-cache-dir --requirement requirements.txt && \
  pip2 install --no-cache-dir . && \
  mv /usr/bin/radon /usr/bin/radon2 && \
  pip3 install --no-cache-dir --requirement requirements.txt && \
  pip3 install --no-cache-dir . && \
  mv /usr/bin/radon /usr/bin/radon3 && \
  rm /var/cache/apk/*

RUN adduser -u 9000 app -D
USER app

WORKDIR /code

VOLUME /code

CMD ["/usr/src/app/codeclimate-radon"]
