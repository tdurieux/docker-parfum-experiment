# syntax=docker/dockerfile:1
FROM --platform=$TARGETPLATFORM golang:1.16-alpine as builder
ARG TARGETARCH
ARG TARGETOS
ARG RELEASE_VERSION
WORKDIR /app/dtm
# RUN go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
EXPOSE 8080
COPY . .
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -ldflags="-s -w -X main.Version=$RELEASE_VERSION"

FROM --platform=$TARGETPLATFORM alpine
COPY --from=builder /app/dtm/dtm /app/dtm/
WORKDIR /app/dtm
ENTRYPOINT ["/app/dtm/dtm"]