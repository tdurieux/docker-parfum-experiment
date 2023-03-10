ARG ALPINE_VERSION=3.11.5

FROM golang:1.13.10 AS build

RUN apt-get update -qq && apt-get install -y -q --no-install-recommends \
  coreutils \
  util-linux \
  uuid-runtime && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src/github.com/docker/app/

COPY . .
ARG TAG="unknown"
RUN make BUILD_TAG=${BUILD_TAG} TAG=${TAG} bin/cnab-run

# local cnab invocation image
FROM alpine:${ALPINE_VERSION} as invocation
RUN apk add --no-cache ca-certificates && adduser -S cnab
USER cnab
COPY --from=build /go/src/github.com/docker/app/bin/cnab-run /cnab/app/run
WORKDIR /cnab/app
CMD /cnab/app/run
