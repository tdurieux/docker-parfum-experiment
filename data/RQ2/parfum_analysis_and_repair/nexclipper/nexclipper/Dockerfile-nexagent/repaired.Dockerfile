FROM golang:1.13 AS builder
ADD . /app/nexagent
WORKDIR /app/nexagent

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o /nexagent ./cmd/nexagent/


FROM alpine:latest
RUN apk update && apk --no-cache add ca-certificates docker
RUN mkdir -p /app/conf
ADD ./cmd/nexagent/conf /app/conf
COPY --from=builder /nexagent /app/nexagent

RUN chmod +x /app/nexagent
ENTRYPOINT ["/app/nexagent"]