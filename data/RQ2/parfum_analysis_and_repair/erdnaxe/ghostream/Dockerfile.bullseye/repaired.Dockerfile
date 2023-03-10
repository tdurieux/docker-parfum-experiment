# Install dependencies then build ghostream
FROM debian:bullseye-slim AS build_base
RUN apt-get update && \
        apt-get install -y --no-install-recommends ca-certificates \
        gcc golang libc6-dev libsrt1 libsrt-openssl-dev musl-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /code
COPY go.* ./
RUN go mod download && go get github.com/markbates/pkger/cmd/pkger
COPY . .
RUN PATH=/root/go/bin:$PATH go generate && go build -o ./out/ghostream .

# Production image
FROM debian:bullseye-slim
RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg libsrt1 musl && rm -rf /var/lib/apt/lists/*;
COPY --from=build_base /code/out/ghostream /app/ghostream
WORKDIR /app
# 2112 for monitoring, 8023 for Telnet, 8080 for Web, 9710 for SRT, 10000-10005 (UDP) for WebRTC
EXPOSE 2112 8023 8080 9710/udp 10000-10005/udp
CMD ["/app/ghostream"]
