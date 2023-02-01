FROM python:3.6-alpine3.10
ARG APP_VERSION
ENV APP_VERSION=$APP_VERSION
RUN apk update \
    && apk upgrade \
    && apk add --no-cache git build-base libffi-dev openssl-dev
RUN pip install --no-cache-dir ply
RUN pip install --no-cache-dir prancer-basic==$APP_VERSION
