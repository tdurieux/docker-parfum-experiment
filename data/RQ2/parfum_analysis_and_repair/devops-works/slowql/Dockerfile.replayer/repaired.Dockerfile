# Build stage
FROM devopsworks/golang-upx:1.15 AS builder
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64
COPY . /app
WORKDIR /app
RUN make replayer && \
    strip ./bin/replayer && \
    /usr/local/bin/upx -9 ./bin/replayer

# Run stage