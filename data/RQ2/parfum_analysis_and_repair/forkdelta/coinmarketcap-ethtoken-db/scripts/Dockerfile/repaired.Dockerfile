FROM python:3.8-alpine3.11

WORKDIR /usr/src/scripts

COPY requirements.txt .
RUN apk --update --upgrade --no-cache add --virtual deps alpine-sdk python3-dev \
      && pip install --no-cache-dir -r requirements.txt \
      && apk del deps

COPY ./ .
RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ["/usr/src/scripts/docker-entrypoint.sh"]
