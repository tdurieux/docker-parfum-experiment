FROM golang:1.18.1-alpine AS builder
RUN apk add --no-cache build-base libpcap-dev
RUN go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

FROM alpine:3.15.4
RUN apk add --no-cache nmap libpcap-dev bind-tools ca-certificates nmap-scripts
COPY --from=builder /go/bin/naabu /usr/local/bin/naabu
ENTRYPOINT ["naabu"]
