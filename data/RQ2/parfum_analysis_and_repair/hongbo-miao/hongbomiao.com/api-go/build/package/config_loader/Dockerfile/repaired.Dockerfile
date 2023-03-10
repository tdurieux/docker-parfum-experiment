FROM golang:1.18.4-alpine AS builder
WORKDIR /usr/src/app

COPY ["api-go/go.mod", "api-go/go.sum", "./"]
RUN go mod download

COPY api-go ./
RUN go build -o ./out/cmd/config_loader/ ./cmd/config_loader/main.go


FROM alpine:3.16.0 AS release
WORKDIR /usr/src/app
ENV GIN_MODE=release

COPY --from=builder /usr/src/app/out/cmd/config_loader/main ./main

EXPOSE 26660
CMD ["./main"]