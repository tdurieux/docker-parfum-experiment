FROM python:2-slim

RUN set -x \
  && apt-get update \
  && apt-get install --no-install-recommends -y musl lame sox flac mktorrent \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
ADD requirements.txt /app

RUN set -x \
  && pip install --no-cache-dir -r requirements.txt

ADD . /app

USER nobody

CMD ["/app/redactedbetter"]
