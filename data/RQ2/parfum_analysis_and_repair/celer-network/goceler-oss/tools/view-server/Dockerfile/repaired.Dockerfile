# syntax=docker/dockerfile:1.0.0-experimental
# Go builder container
FROM golang:1.13-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git ca-certificates
RUN --mount=type=secret,id=github_access_token,required \
    git config --global url."https://`cat /run/secrets/github_access_token`:@github.com/".insteadOf "https://github.com/"

WORKDIR /goCeler-oss
ADD . /goCeler-oss
RUN go build -o /tmp/osp-cli tools/osp-cli/osp_cli.go && go build -o /tmp/channel-view-server tools/view-server/view_server.go

# Second stage container for deployment