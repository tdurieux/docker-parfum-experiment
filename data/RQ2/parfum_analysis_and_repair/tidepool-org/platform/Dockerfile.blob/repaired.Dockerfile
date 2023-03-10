# Development
FROM golang:1.18.3-alpine AS development
WORKDIR /go/src/github.com/tidepool-org/platform
RUN apk --no-cache add git make tzdata && \
    apk add --no-cache ca-certificates tzdata && \
    go install github.com/githubnemo/CompileDaemon@v1.4.0 && \
    adduser -D tidepool && \
    chown -R tidepool /go/src/github.com/tidepool-org/platform
USER tidepool
COPY . .
ENV SERVICE=services/blob
RUN ["make", "service-build"]
CMD ["make", "service-start"]

# Production