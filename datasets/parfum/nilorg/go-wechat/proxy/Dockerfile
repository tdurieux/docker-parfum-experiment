#build stage
FROM nilorg/golang:1.16.4 AS builder
WORKDIR /src
COPY . .
RUN go build -o ./bin/app -i ./proxy/main.go

#final stage
FROM nilorg/alpine:latest
WORKDIR /workspace

COPY --from=builder /src/bin/app .
ENTRYPOINT ./app