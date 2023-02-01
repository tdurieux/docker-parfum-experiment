FROM segment/integration-worker:3.x

COPY . /integration
WORKDIR /integration

RUN apk add --no-cache --update python make g++ \
  && npm rebuild \
  && apk del --purge python make g++
