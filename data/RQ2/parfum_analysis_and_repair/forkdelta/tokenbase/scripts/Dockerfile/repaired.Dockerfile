FROM python:3.8.2-alpine

WORKDIR /usr/src/scripts

COPY requirements.txt .
RUN apk --update --upgrade --no-cache add git libxml2 libxslt \
      && apk --update --upgrade --no-cache add --virtual deps alpine-sdk python3-dev libxml2-dev libxslt-dev \
      && pip install --no-cache-dir -r requirements.txt \
      && apk del deps

COPY ./ .
RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ["/usr/src/scripts/docker-entrypoint.sh"]
