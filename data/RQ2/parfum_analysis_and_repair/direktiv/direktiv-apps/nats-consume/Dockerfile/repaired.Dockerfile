FROM golang:1.15-buster as build

WORKDIR /app
COPY ./main.go ./
COPY ./go.mod ./
COPY ./go.sum ./
RUN go get -u -v
RUN CGO_ENABLED=0 go build -o /nats -ldflags="-s -w" main.go

FROM alpine:latest as certs
RUN apk --update --no-cache add ca-certificates

FROM scratch
COPY --from=build /nats /
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
CMD ["/nats"]
