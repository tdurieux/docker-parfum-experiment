FROM golang:1.16-alpine3.13 AS builder
WORKDIR /app
COPY go.sum go.mod ./
RUN go mod download
ADD . /app
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o gitsee .
FROM alpine
COPY --from=builder /app/gitsee /app/gitsee
CMD ["/app/gitsee"]