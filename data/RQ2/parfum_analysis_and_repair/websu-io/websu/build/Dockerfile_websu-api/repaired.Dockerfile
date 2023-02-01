FROM golang:1.14 AS builder

WORKDIR /go/src/github.com/websu-io/websu
COPY go.mod go.sum ./
# Download dependencies and cache in docker layer
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build ./cmd/websu-api && mv websu-api /

FROM alpine:3
WORKDIR /websu
COPY --from=builder /websu-api /websu/websu-api
ADD templates /websu/templates
RUN apk --no-cache add ca-certificates
RUN mkdir static && \
    wget https://github.com/websu-io/websu-ui/releases/latest/download/build.tar.gz && \
    tar -xzf build.tar.gz -C static && \
    rm build.tar.gz
ENV ENABLE_ADMIN_APIS=true
ENTRYPOINT ["/websu/websu-api"]
EXPOSE 8000/tcp