# SET GO AND ALPINE VERSIONS
ARG GO_VER=1.15.3
ARG ALPINE_VER=3.12

# COPY AND BUILD SOURCE
FROM golang:${GO_VER}-alpine${ALPINE_VER} AS builder
COPY . /src
RUN cd /src/jira-ui && go build -o /tmp/jira-ui main.go

########## ########## ##########

# START A LEAN CONTAINER
FROM alpine:${ALPINE_VER}

# COPY ARTIFACT FROM BUILDER CONTAINER
COPY --from=builder /tmp/jira-ui /usr/local/bin/jira-ui

# INSTALL EDITORS
RUN apk add --no-cache vim nano

# SETUP UNDERPRIVILEGED USER AND LINK CONFIG