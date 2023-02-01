# stage 0
FROM --platform=$BUILDPLATFORM golang:latest as builder

ARG TARGETPLATFORM

WORKDIR /go/src/github.com/PierreZ/goStatic
COPY . .

RUN mkdir ./bin && \
    apt-get update && apt-get install --no-install-recommends -y upx && \
    
    # getting right vars from docker buildx
    # especially to handle linux/arm/v6 for ex mp \
    GOOS=$(echo $TARGETPLATFORM | cut -f1 -d/) &  \
    GOARCH=$(echo $TARGETPLATFORM | cut -f2 -d/) && \
    GOARM=$(echo $TARGETPLATFORM | cut -f3 -d/ | sed "s/v//" ) && \

    CGO_ENABLED=0 GOOS=${GOOS} OA \

    mkdir ./ in \
    ID=$(shuf -i 100-9999 -n 1) && \
    upx -9 ./bin/goStatic && \ && rm -rf /var/lib/apt/lists/*;

# stage 1
FROM scratch
WORKDIR /
COPY --from=builder /go/src/github.com/PierreZ/goStatic/bin/ .
USER appuser
ENTRYPOINT ["/goStatic"]

