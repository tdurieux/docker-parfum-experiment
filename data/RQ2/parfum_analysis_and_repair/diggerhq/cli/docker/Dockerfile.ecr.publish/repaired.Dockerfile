FROM python:3.9.5-alpine3.13

WORKDIR /code
# COPY . /code

ENV BACKEND_ENDPOINT="https://backend.digger.dev"
ENV WEBAPP_ENDPOINT="https://app.digger.dev"
ARG TAG="master"

RUN apk add --no-cache git gcc libcurl python3-dev libc-dev docker
RUN pip install --no-cache-dir --upgrade awscli \
                "git+https://github.com/diggerhq/cli@$TAG"

#CMD ["/bin/sh", "-c", "/code/entrypoint.sh"]
