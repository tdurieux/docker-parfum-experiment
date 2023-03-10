# multi-arch image building for yurt-controller-manager

FROM --platform=${BUILDPLATFORM} golang:1.17.1 as builder
ADD . /build
ARG TARGETOS TARGETARCH GIT_VERSION GOPROXY MIRROR_REPO
WORKDIR /build/
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} GIT_VERSION=${GIT_VERSION} make build WHAT=cmd/yurt-controller-manager

FROM --platform=${TARGETPLATFORM} alpine:3.14
ARG TARGETOS TARGETARCH MIRROR_REPO
RUN if [ ! -z "${MIRROR_REPO+x}" ]; then sed -i "s/dl-cdn.alpinelinux.org/${MIRROR_REPO}/g" /etc/apk/repositories; fi && \
    apk add --no-cache ca-certificates bash libc6-compat && update-ca-certificates && rm /var/cache/apk/*
COPY --from=builder /build/_output/local/bin/${TARGETOS}/${TARGETARCH}/yurt-controller-manager /usr/local/bin/yurt-controller-manager
ENTRYPOINT ["/usr/local/bin/yurt-controller-manager"]