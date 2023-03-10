FROM golang:1.18 AS build
WORKDIR /veneur/
COPY . .
RUN go build -a -ldflags "-X github.com/stripe/veneur.VERSION=${VERSION}" -o /build/veneur ./cmd/veneur &&\
    go build -a -ldflags "-X github.com/stripe/veneur.VERSION=${VERSION}" -o /build/veneur-emit ./cmd/veneur-emit &&\
    go build -a -ldflags "-X github.com/stripe/veneur.VERSION=${VERSION}" -o /build/veneur-prometheus ./cmd/veneur-prometheus &&\
    go build -a -ldflags "-X github.com/stripe/veneur.VERSION=${VERSION}" -o /build/veneur-proxy ./cmd/veneur-proxy


FROM debian:sid AS release
LABEL maintainer="The Stripe Observability Team <support@stripe.com>"
RUN apt-get update && apt-get -y --no-install-recommends install ca-certificates && rm -rf /var/lib/apt/lists/*;
WORKDIR /veneur/
EXPOSE 8126/UDP 8126/TCP 8127/TCP 8128/UDP
COPY --from=build /build/* /veneur/
COPY example.yaml /veneur/config.yaml
COPY example_proxy.yaml /veneur/config_proxy.yaml
CMD ["/veneur/veneur", "-f", "config.yaml"]
