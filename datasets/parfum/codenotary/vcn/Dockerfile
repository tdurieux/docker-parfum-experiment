# Copyright (c) 2018-2021 Codenotary, Inc. All Rights Reserved.
# This software is released under Apache License 2.0.
# The full license information can be found under:
# https://www.apache.org/licenses/LICENSE-2.0

FROM golang:1.16.6-buster as build
WORKDIR /src
COPY . .
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 make static

FROM alpine:3.12 as ca
RUN apk add --no-cache \
		ca-certificates

FROM scratch
COPY --from=ca /etc/ssl/certs /etc/ssl/certs
COPY --from=build /src/cas /bin/cas

ENTRYPOINT [ "/bin/cas" ]
