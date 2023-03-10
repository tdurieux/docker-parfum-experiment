FROM golang:1.10-alpine AS compile
COPY . /go/src/github.com/containerbuilding/cbi
RUN go build -ldflags="-s -w" -o /cbipluginhelper github.com/containerbuilding/cbi/cmd/cbipluginhelper

FROM alpine:3.7
RUN apk add --no-cache \
  # for Git context
  git openssh-client \
  # for HTTP context. bsdtar (libarchive-tools) is required for auto-detecting gzip stream.
  ca-certificates libarchive-tools && \
# For Rclone context (FIXME: support non-amd64)
  wget https://downloads.rclone.org/v1.40/rclone-v1.40-linux-amd64.zip && \
  unzip rclone-v1.40-linux-amd64.zip && \
  cp rclone-v1.40-linux-amd64/rclone / && \
  rm -rf rclone-v1.40-linux-amd64
# For docker-like builders
ADD hack/dockerfiles/docker-build-push.sh /
ADD hack/dockerfiles/s2i-build-push.sh /
COPY --from=compile /cbipluginhelper /cbipluginhelper
ENTRYPOINT ["/cbipluginhelper", "--debug"]