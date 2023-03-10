ARG GO_VERSION=1.13.15
ARG BUILDX_COMMIT=v0.5.1
ARG BUILDX_REPO=https://github.com/docker/buildx.git

FROM golang:${GO_VERSION}-buster AS build
ARG BUILDX_REPO
RUN git clone "${BUILDX_REPO}" /buildx
WORKDIR /buildx
ARG BUILDX_COMMIT
RUN git fetch origin "${BUILDX_COMMIT}":build && git checkout build
ARG GOOS
ARG GOARCH
# Keep these essentially no-op var settings for debug purposes.
# It allows us to see what the GOOS/GOARCH that's being built for is.
RUN GOOS="${GOOS}" GOARCH="${GOARCH}" BUILDX_COMMIT="${BUILDX_COMMIT}"; \
    pkg="github.com/docker/buildx"; \
    ldflags="\
      -X \"${pkg}/version.Version=$(git describe --tags)\" \
      -X \"${pkg}/version.Revision=$(git rev-parse --short HEAD)\" \
      -X \"${pkg}/version.Package=buildx\" \
    "; \
    go build -mod=vendor -ldflags "${ldflags}" -o /usr/bin/buildx ./cmd/buildx

FROM golang:${GO_VERSION}-buster
COPY --from=build /usr/bin/buildx /usr/bin/buildx
ENTRYPOINT ["/usr/bin/buildx"]