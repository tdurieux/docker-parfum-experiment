# Builder image
FROM golang:1.12.5 AS builder

WORKDIR /build

# Docker Cloud args, from hooks/build.
ARG CACHE_TAG
ENV CACHE_TAG ${CACHE_TAG}

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -v -ldflags '-w -s -X 'github.com/WanderaOrg/git2kube/cmd.Version=${CACHE_TAG}

# Runtime image
FROM alpine:3.8
RUN apk --no-cache add ca-certificates

RUN apk --no-cache --virtual .openssh add openssh \
    && mkdir -p /etc/ssh \
    && ssh-keyscan -t rsa github.com > /etc/ssh/ssh_known_hosts \
    && apk del .openssh

COPY --from=builder /build/git2kube /app/git2kube
WORKDIR /app

ENTRYPOINT ["./git2kube"]
