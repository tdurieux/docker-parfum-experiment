FROM --platform=$BUILDPLATFORM rfratto/seego:latest as build
ARG TARGETPLATFORM
ARG BUILDPLATFORM

# Use custom Go version instead of one prepacked in seego
ENV GOLANG_VERSION 1.18
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 e85278e98f57cdb150fe8409e6e5df5343ecb13cebf03a5d5ff12bd55a80264f
RUN  rm -rf /usr/local/go                                           \
  && curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz             \
  && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
  && tar -C /usr/local -xzf golang.tar.gz                           \
  && rm golang.tar.gz
RUN apt update && apt install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*;
COPY . /src/agent
WORKDIR /src/agent
ARG RELEASE_BUILD=true
ARG IMAGE_TAG

RUN make clean && IMAGE_TAG=${IMAGE_TAG} RELEASE_BUILD=${RELEASE_BUILD} BUILD_IN_CONTAINER=false DRONE=true make grafana-agent-crow

FROM debian:bullseye-slim
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /src/agent/tools/crow/grafana-agent-crow /bin/grafana-agent-crow
ENTRYPOINT ["/bin/grafana-agent-crow"]
