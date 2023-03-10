# build docker image include source code and go env for develop or test
FROM golang:1.17.5

LABEL maintainer="Tencent BlueKing"

ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64

WORKDIR /go/src/

ARG VERSION
ARG GITCOMMIT

RUN apt-get update && apt-get install --no-install-recommends -y make vim && rm -rf /var/lib/apt/lists/*;

COPY . .
RUN go mod download
RUN make build VERSION=$VERSION GITCOMMIT=$GITCOMMIT

# package swagger dependency file
RUN cp -R ./third_party/swagger-ui/* ./swagger/

ENV EXAMPLE_FILE_BASE_DIR=/go/src/pkg/resource/example

ENV FORM_TMPL_FILE_BASE_DIR=/go/src/pkg/resource/form/tmpl

ENV LOCALIZE_FILE_PATH=/go/src/pkg/i18n/locale/lc_msgs.yaml

# default log file base dir
RUN mkdir -p /tmp/logs
