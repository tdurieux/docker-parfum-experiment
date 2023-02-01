FROM golang AS builder

ENV APP_PATH /go/src/github.com/elsevier-core-engineering/replicator

RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

COPY . $APP_PATH

RUN \
  apt-get install -y git && \
  go get -u github.com/mitchellh/gox && \
  ./scripts/build.sh

FROM alpine:edge AS app
LABEL maintainer Eric Westfall<(eawestfall@gmail.com> (@eawestfall)
LABEL vendor "Elsevier Core Engineering"
LABEL documentation "https://github.com/elsevier-core-engineering/replicator"

ENV APP_PATH /go/src/github.com/elsevier-core-engineering/replicator
ENV REPLICATOR_VERSION v1.0.3

WORKDIR /usr/local/bin/

RUN \
  apk --no-cache add \
  ca-certificates

COPY --from=builder $APP_PATH/pkg/linux-amd64-replicator replicator

RUN chmod +x replicator

ENTRYPOINT [ "replicator" ]
CMD [ "agent", "--help" ]
