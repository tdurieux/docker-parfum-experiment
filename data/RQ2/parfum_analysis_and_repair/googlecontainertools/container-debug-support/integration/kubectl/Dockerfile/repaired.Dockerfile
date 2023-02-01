# Simple multi-platform image that includes kubectl and curl
FROM --platform=$BUILDPLATFORM curlimages/curl
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

# curlimages/curl runs as curl-user and cannot install into /usr/bin