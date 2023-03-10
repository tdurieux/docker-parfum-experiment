FROM golang:1.14.1-alpine3.11
RUN apk add --no-cache build-base

WORKDIR /build
COPY . ./

RUN CGO_ENABLED=0 go build -o iovnscli ./cmd/iovnscli
RUN CGO_ENABLED=0 go build -o iovnsd ./cmd/iovnsd

FROM alpine
ENV HOME=/iovns
ENV MONIKER=k8sclient
COPY --from=0 /build/iovnscli /bin/iovnscli
COPY --from=0 /build/iovnsd /bin/iovnsd
WORKDIR /iovns
COPY ./scripts/entrypoint.sh entrypoint.sh
COPY ./scripts/accounts.sh accounts.sh
RUN chmod +x entrypoint.sh
RUN ls -al
ENTRYPOINT ["sh", "entrypoint.sh"]
