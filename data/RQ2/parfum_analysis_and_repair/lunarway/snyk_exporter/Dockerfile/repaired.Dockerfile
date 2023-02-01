FROM golang:1.18.3 as builder
WORKDIR /src
ENV CGO_ENABLED=0
ENV GOOS=linux

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build -o /tmp/snyk_exporter

FROM scratch

ENTRYPOINT [ "/snyk_exporter" ]
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /tmp/snyk_exporter /
