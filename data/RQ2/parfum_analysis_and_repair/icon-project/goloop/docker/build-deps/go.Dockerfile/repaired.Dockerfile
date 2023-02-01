ARG GOLANG_VERSION
ARG ALPINE_VERSION
FROM golang:${GOLANG_VERSION}-alpine${ALPINE_VERSION}
RUN apk add --no-cache make git build-base
RUN if [[ $(uname -m | grep -E '^arm|^aarch' | wc -l) == 1 ]]; then \
 apk add --no-cache binutils-gold; fi
ENV GO111MODULE on

ARG GOLOOP_GOMOD_SHA
#ENV GOLOOP_GOMOD_SHA ${GOLOOP_GOMOD_SHA}
LABEL GOLOOP_GOMOD_SHA="$GOLOOP_GOMOD_SHA"
ADD go.mod go.sum /goloop/
WORKDIR /goloop

RUN echo "go mod download $GOLOOP_GOMOD_SHA" && go mod download
