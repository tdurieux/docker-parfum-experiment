#################
# Compile image #
#################
ARG BASE_IMAGE=ghcr.io/tinyzimmer/kvdi:build-base-latest
FROM ${BASE_IMAGE} as builder

# Go build options
ENV GO111MODULE=on
## CGO is required for GST bindings
ENV CGO_ENABLED=1

RUN apk add --no-cache pulseaudio-dev glib-dev gstreamer-dev gst-plugins-base-dev pkgconfig gcc musl-dev

# Copy go code
COPY apis/        /build/apis
COPY pkg/         /build/pkg
COPY cmd/kvdi-proxy  /build/cmd/kvdi-proxy

# Build the binary
ARG LDFLAGS
RUN go build \
  -o /tmp/kvdi-proxy \
  -ldflags="${LDFLAGS}" \
  ./cmd/kvdi-proxy && upx /tmp/kvdi-proxy

###############
# Final Image #
###############
FROM alpine

RUN apk add --update --no-cache \
      libpulse gstreamer gst-plugins-good gst-plugins-base \
      && adduser -D -u 9000 audioproxy

COPY --from=builder /tmp/kvdi-proxy /kvdi-proxy

EXPOSE 8443
ENTRYPOINT ["/kvdi-proxy"]
