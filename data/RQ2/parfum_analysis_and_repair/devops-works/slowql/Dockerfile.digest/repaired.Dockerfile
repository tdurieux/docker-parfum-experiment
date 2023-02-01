# Build stage
FROM devopsworks/golang-upx:1.16 AS builder
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64
COPY . /app
WORKDIR /app
RUN make digest && \
    strip ./bin/digest && \
    /usr/local/bin/upx -9 ./bin/digest

# Run stage