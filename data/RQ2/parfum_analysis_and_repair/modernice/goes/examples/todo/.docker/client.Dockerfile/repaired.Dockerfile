FROM golang:1.18 AS build

WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY . .
WORKDIR /build/examples/todo
RUN CGO_ENABLED=0 go build -o ./client ./cmd/client

FROM alpine

COPY --from=build /build/examples/todo/client /client

ENTRYPOINT ["/client"]