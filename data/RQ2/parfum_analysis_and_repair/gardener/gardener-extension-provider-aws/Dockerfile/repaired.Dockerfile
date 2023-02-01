############# builder
FROM golang:1.18.3 AS builder

WORKDIR /go/src/github.com/gardener/gardener-extension-provider-aws
COPY . .
RUN make install

############# base
FROM gcr.io/distroless/static-debian11:nonroot AS base

############# gardener-extension-provider-aws
FROM base AS gardener-extension-provider-aws
WORKDIR /

COPY charts /charts
COPY --from=builder /go/bin/gardener-extension-provider-aws /gardener-extension-provider-aws
ENTRYPOINT ["/gardener-extension-provider-aws"]

############# gardener-extension-admission-aws