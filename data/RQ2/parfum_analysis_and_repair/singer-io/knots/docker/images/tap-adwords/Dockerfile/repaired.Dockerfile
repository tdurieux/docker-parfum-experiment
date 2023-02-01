FROM python:3.6-alpine
ARG version
RUN apk update && \
  apk add --no-cache --virtual .build-deps gcc musl-dev linux-headers libxml2-dev libxslt-dev && \
  pip install --no-cache-dir tap-adwords==${version}

WORKDIR /app
CMD ["tap-adwords"]