# How to start a container: https://postgres.ai/docs/how-to-guides/administration/engine-manage

# Compile stage
FROM golang:1.18 AS build-env

# Build Delve
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Build DLE (Uncomment if the binary doesn't compile locally).
# ADD . /dockerdev
# WORKDIR /dockerdev
# RUN GO111MODULE=on CGO_ENABLED=0 go build -gcflags="all=-N -l" -o /dblab-server-debug ./cmd/database-lab/main.go

# Final stage
FROM docker:20.10.12

# Install dependencies
RUN apk update \
  && apk add zfs=2.1.4-r0 --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main \
  && apk add --no-cache lvm2 bash util-linux
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.13/main' >> /etc/apk/repositories \
  && echo 'http://dl-cdn.alpinelinux.org/alpine/v3.13/community' >> /etc/apk/repositories \
  && apk add --no-cache bcc-tools=0.18.0-r0 bcc-doc=0.18.0-r0 && ln -s $(which python3) /usr/bin/python \
  # TODO: remove after release the PR: https://github.com/iovisor/bcc/pull/3286 (issue: https://github.com/iovisor/bcc/issues/3099)
  && wget https://raw.githubusercontent.com/iovisor/bcc/master/tools/biosnoop.py -O /usr/share/bcc/tools/biosnoop

ENV PATH="${PATH}:/usr/share/bcc/tools"

WORKDIR /home/dblab

EXPOSE 2345 40000

# Replace if the binary doesn't compile locally.
# COPY --from=build-env /dblab-server-debug ./bin/dblab-server-debug
COPY ./bin/dblab-server-debug ./bin/dblab-server-debug

COPY --from=build-env /go/bin/dlv ./
COPY ./configs/standard ./standard
COPY ./api ./api
COPY ./scripts ./scripts

CMD ["./dlv", "--listen=:40000", "--headless=true", "--api-version=2", "--accept-multiclient", "exec", "./bin/dblab-server-debug"]
