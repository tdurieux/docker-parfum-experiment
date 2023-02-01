FROM golang:1.13 AS builder
WORKDIR /cistern/
RUN apt-get update && yes | apt-get install -y --no-install-recommends pandoc && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN go run ./cmd/make cistern

FROM alpine:latest
WORKDIR /cistern
RUN apk add --no-cache man ca-certificates less
ENV PAGER less
COPY --from=builder /cistern/build/cistern /bin
CMD []
ENTRYPOINT ["cistern"]
