FROM python:3.9-alpine3.15
ENV APP_VERSION=$version
RUN apk update     && apk upgrade && apk add --no-cache git build-base libffi-dev openssl-dev
COPY opadir/opa /usr/local/bin/opa
RUN chmod +x /usr/local/bin/opa
COPY helmdir/linux-amd64/helm /usr/local/bin/helm
RUN chmod +x /usr/local/bin/helm
RUN pip install --no-cache-dir ply
RUN pip install --no-cache-dir prancer-basic==$version