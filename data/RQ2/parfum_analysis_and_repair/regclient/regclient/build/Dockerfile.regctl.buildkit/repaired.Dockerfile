# syntax=docker/dockerfile:1

ARG REGISTRY=docker.io
ARG ALPINE_VER=3
ARG GO_VER=1.17-alpine

FROM --platform=$BUILDPLATFORM ${REGISTRY}/library/golang:${GO_VER} as golang
RUN apk add --no-cache \
      ca-certificates \
      git \
      make
RUN addgroup -g 1000 appuser \
 && adduser -u 1000 -G appuser -D appuser \
 && mkdir -p /home/appuser/.regctl \
 && chown -R appuser /home/appuser/.regctl
WORKDIR /src

FROM --platform=$BUILDPLATFORM golang as dev
COPY --link . /src/
ENV PATH=${PATH}:/src/bin
CMD make bin/regctl && bin/regctl

FROM --platform=$BUILDPLATFORM dev as build
ARG TARGETOS
ARG TARGETARCH
RUN --mount=type=cache,id=gomod,target=/go/pkg/mod/cache \
    --mount=type=cache,id=goroot,target=/root/.cache/go-build \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    make bin/regctl
USER appuser
CMD [ "bin/regctl" ]

FROM scratch as artifact
COPY --link --from=build /src/bin/regctl /regctl

FROM --platform=$BUILDPLATFORM golang as docker-cred-ecr-login
ARG TARGETOS
ARG TARGETARCH
RUN --mount=type=cache,id=gomod,target=/go/pkg/mod/cache \
    --mount=type=cache,id=goroot,target=/root/.cache/go-build \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go install github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login@latest \
 && ( cp "${GOPATH}/bin/docker-credential-ecr-login" /usr/local/bin/docker-credential-ecr-login \
   || cp "${GOPATH}/bin/${TARGETOS}_${TARGETARCH}/docker-credential-ecr-login" /usr/local/bin/docker-credential-ecr-login )

FROM --platform=$BUILDPLATFORM golang as docker-cred-gcr
ARG TARGETOS
ARG TARGETARCH
RUN --mount=type=cache,id=gomod,target=/go/pkg/mod/cache \
    --mount=type=cache,id=goroot,target=/root/.cache/go-build \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go install github.com/GoogleCloudPlatform/docker-credential-gcr@latest \
 && ( cp "${GOPATH}/bin/docker-credential-gcr" /usr/local/bin/docker-credential-gcr \
   || cp "${GOPATH}/bin/${TARGETOS}_${TARGETARCH}/docker-credential-gcr" /usr/local/bin/docker-credential-gcr )

FROM ${REGISTRY}/library/alpine:${ALPINE_VER} as release-alpine
COPY --link --from=build /etc/passwd /etc/group /etc/
COPY --link --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --link --from=build --chown=1000:1000 /home/appuser/ /home/appuser/
COPY --link --from=docker-cred-ecr-login /usr/local/bin/docker-credential-* /usr/local/bin/
COPY --link --from=docker-cred-gcr /usr/local/bin/docker-credential-* /usr/local/bin/
COPY --link --from=build /src/bin/regctl /usr/local/bin/regctl
USER appuser
CMD [ "regctl", "--help" ]

ARG BUILD_DATE
ARG VCS_REF
LABEL maintainer="" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.authors="Regclient contributors" \
      org.opencontainers.image.url="https://github.com/regclient/regclient" \
      org.opencontainers.image.documentation="https://github.com/regclient/regclient" \
      org.opencontainers.image.source="https://github.com/regclient/regclient" \
      org.opencontainers.image.version="latest" \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.vendor="" \
      org.opencontainers.image.licenses="Apache 2.0" \
      org.opencontainers.image.title="regctl" \
      org.opencontainers.image.description=""

FROM scratch as release-scratch
ADD  --link build/root.tgz /
COPY --link --from=build /etc/passwd /etc/group /etc/
COPY --link --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --link --from=build --chown=1000:1000 /home/appuser/ /home/appuser/
COPY --link --from=build /src/bin/regctl /regctl
USER appuser
ENTRYPOINT [ "/regctl" ]

ARG BUILD_DATE
ARG VCS_REF
LABEL maintainer="" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.authors="Regclient contributors" \
      org.opencontainers.image.url="https://github.com/regclient/regclient" \
      org.opencontainers.image.documentation="https://github.com/regclient/regclient" \
      org.opencontainers.image.source="https://github.com/regclient/regclient" \
      org.opencontainers.image.version="latest" \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.vendor="" \
      org.opencontainers.image.licenses="Apache 2.0" \
      org.opencontainers.image.title="regctl" \
      org.opencontainers.image.description=""