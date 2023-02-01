FROM golang:alpine AS build

RUN apk --update --no-cache add ca-certificates


FROM ARG_FROM

LABEL maintainer="Team Honeycomb <bees@honeycomb.io>"

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
ADD bin/ARG_ARCH/ARG_BIN /ARG_BIN

ENTRYPOINT ["/ARG_BIN"]
