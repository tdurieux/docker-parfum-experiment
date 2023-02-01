FROM python:3.7.6-alpine

ARG BRANCH=heroku-deploy

MAINTAINER coolboi567 <coolboi567@gmail.com>

WORKDIR /opt/dnstwister

COPY . /opt/dnstwister

RUN apk update && apk add --no-cache --virtual .build-deps gcc musl-dev && \
    pip install --no-cache-dir pipenv && pipenv install --dev && \
    apk del .build-deps

ENTRYPOINT ["pipenv", "run"]

CMD ["python", "local_server.py"]
