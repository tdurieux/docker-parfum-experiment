FROM --platform=$BUILDPLATFORM golang:alpine AS bld
ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETVARIANT
ARG BUILDPLATFORM
RUN mkdir /mquery
WORKDIR /mquery
COPY Makefile go.mod go.sum vendor mquery.go /mquery
RUN apk add --no-cache make
RUN make static TARGETARCH=$TARGETARCH TARGETVARIANT=${TARGETVARIANT#v}

FROM scratch
COPY --from=bld /mquery/mquery /mquery
COPY --from=bld /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
ENTRYPOINT [ "/mquery" ]
