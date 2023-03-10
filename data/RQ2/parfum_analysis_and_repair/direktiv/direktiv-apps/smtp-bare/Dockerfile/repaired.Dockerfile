FROM golang:1.16.13-buster as build

WORKDIR /app
COPY ./main.go ./
COPY ./go.mod ./
COPY ./go.sum ./

RUN go get -u -v
RUN CGO_ENABLED=0 go build -o /smtp-bare -ldflags="-s -w" main.go

FROM alpine:latest as certs
RUN apk --update --no-cache add ca-certificates

FROM scratch

COPY --from=build /smtp-bare /
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
CMD ["/smtp-bare"]
