FROM golang:1.16 AS builder

WORKDIR /app

RUN go install github.com/go-task/task/v3/cmd/task@latest

COPY go.mod go.sum ./
RUN go mod download

COPY . ./

RUN task build-server

FROM frolvlad/alpine-glibc:glibc-2.34

WORKDIR /app

COPY --from=builder /app/builds/pando-server .
Add assets assets

EXPOSE 7778

ENTRYPOINT ["/app/pando-server"]