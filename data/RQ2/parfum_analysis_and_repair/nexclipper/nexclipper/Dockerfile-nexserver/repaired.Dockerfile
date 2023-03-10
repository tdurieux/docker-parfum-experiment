FROM golang:1.13 AS builder
ADD . /app/nexserver
WORKDIR /app/nexserver

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o /nexserver ./cmd/nexserver/


FROM alpine:latest
RUN apk --no-cache add ca-certificates tzdata
RUN mkdir -p /app/conf
ADD ./cmd/nexserver/conf /app/conf
COPY --from=builder /nexserver /app/nexserver

RUN chmod +x /app/nexserver
ENTRYPOINT ["/app/nexserver"]
EXPOSE 18000