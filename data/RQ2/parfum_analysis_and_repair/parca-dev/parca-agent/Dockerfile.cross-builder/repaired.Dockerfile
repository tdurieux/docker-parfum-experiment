ARG GOLANG_CROSS_VERSION
FROM --platform="${BUILDPLATFORM:-linux/amd64}" docker.io/goreleaser/goreleaser-cross:${GOLANG_CROSS_VERSION}

RUN apt-get update -y && \
    apt-get install --no-install-recommends -yq libelf-dev zlib1g-dev \
    libelf-dev:arm64 zlib1g-dev:arm64 \
    lld && rm -rf /var/lib/apt/lists/*;
