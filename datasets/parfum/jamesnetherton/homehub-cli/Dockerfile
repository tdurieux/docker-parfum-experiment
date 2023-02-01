FROM golang:alpine as compile

RUN apk --no-cache add make git

COPY . /homehub-cli

ENV CGO_ENABLED=0
RUN cd /homehub-cli && \
    make build && \
    cp build/homehub-cli /go/bin/homehub-cli

FROM scratch

# Avoid cli prompt displaying unknown@ by default
ENV USER=docker

COPY --from=compile /go/bin/homehub-cli /homehub-cli

ENTRYPOINT ["/homehub-cli"]
