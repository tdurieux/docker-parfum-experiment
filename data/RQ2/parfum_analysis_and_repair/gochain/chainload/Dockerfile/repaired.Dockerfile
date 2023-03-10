# build stage
FROM golang:1.14-alpine AS build-env
RUN apk --no-cache add build-base git mercurial gcc
ENV D=/chainload
WORKDIR $D
# cache dependencies
ADD go.mod $D
ADD go.sum $D
RUN go mod download
# build
ADD . $D
ARG VERSION="unknown"
ENV VERSION=$VERSION
RUN cd $D && go install -ldflags "-X main.version=${VERSION}" ./cmd/chainload

# final stage