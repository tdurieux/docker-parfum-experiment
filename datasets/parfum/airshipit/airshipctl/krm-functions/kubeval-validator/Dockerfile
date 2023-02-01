ARG GO_IMAGE=quay.io/airshipit/golang:1.16.8-alpine
ARG PLUGINS_RELEASE_IMAGE=quay.io/airshipit/alpine:3.13.5
FROM ${GO_IMAGE} as function
ARG GOPROXY=""

# Inject custom root certificate authorities if needed
# Docker does not have a good conditional copy statement and requires that a source file exists
# to complete the copy function without error.  Therefore the README.md file will be copied to
# the image every time even if there are no .crt files.
COPY ./certs/* /usr/local/share/ca-certificates/
RUN update-ca-certificates
ENV PATH "/usr/local/go/bin:$PATH"
ENV CGO_ENABLED=0
WORKDIR /go/src/
COPY image/go.mod image/go.sum ./
RUN go mod download
COPY image/ ./
RUN go build -v -o /usr/local/bin/config-function ./

FROM ${PLUGINS_RELEASE_IMAGE} as release
# Inject custom root certificate authorities if needed
# Docker does not have a good conditional copy statement and requires that a source file exists
# to complete the copy function without error.  Therefore the README.md file will be copied to
# the image every time even if there are no .crt files.
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
COPY ./certs/* /usr/local/share/ca-certificates/
RUN update-ca-certificates
ENV PYTHONUNBUFFERED=1
RUN echo "**** install build tools ****" && \
    apk add --no-cache build-base && \
    echo "**** install Python ****" && \
    apk add --no-cache python3 python3-dev && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache-dir --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

RUN pip3 install --no-cache-dir 'ruamel.yaml==0.16.13' 'openapi2jsonschema==0.9.0' 'openapi-spec-validator==0.3.0'
COPY --from=function /usr/local/bin/config-function /usr/local/bin/config-function
COPY image/extract-openapi.py /usr/local/bin/
CMD ["config-function"]
