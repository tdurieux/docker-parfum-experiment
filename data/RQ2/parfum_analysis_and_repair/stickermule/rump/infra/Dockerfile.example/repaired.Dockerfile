# Example of rump running in a container
# build: docker build -t temp/rump -f Dockerfile.example .
# run: docker run --rm temp/rump

FROM alpine:latest

RUN apk add --no-cache curl

RUN \
 VERSION=1.0.0 && \
ARCH=linux-amd64 && \
NAME=rump-$VERSION-$ARCH && \
 curl -f -L -o /rump \
https://github.com/stickermule/rump/releases/download/$VERSION/$NAME && \
chmod +x /rump

ENTRYPOINT ["/rump"]
