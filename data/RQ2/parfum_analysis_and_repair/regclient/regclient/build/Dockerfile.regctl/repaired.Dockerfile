ARG REGISTRY=docker.io
ARG ALPINE_VER=3
ARG GO_VER=1.17-alpine

FROM ${REGISTRY}/library/golang:${GO_VER} as golang
RUN apk add --no-cache \
      ca-certificates \
      git \
      make
RUN adduser -D appuser \
 && mkdir -p /home/appuser/.regctl \
 && chown -R appuser /home/appuser/.regctl
WORKDIR /src

FROM golang as dev
COPY . /src/
ENV PATH=${PATH}:/src/bin
CMD make bin/regctl && bin/regctl

FROM dev as build
RUN make bin/regctl
USER appuser
CMD [ "bin/regctl" ]

FROM golang as docker-cred-ecr-login
ARG TARGETOS
ARG TARGETARCH
RUN go install github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login@latest \
 && ( cp "${GOPATH}/bin/docker-credential-ecr-login" /usr/local/bin/docker-credential-ecr-login \
   || cp "${GOPATH}/bin/${TARGETOS}_${TARGETARCH}/docker-credential-ecr-login" /usr/local/bin/docker-credential-ecr-login )

FROM golang as docker-cred-gcr
ARG TARGETOS
ARG TARGETARCH
RUN go install github.com/GoogleCloudPlatform/docker-credential-gcr@latest \
 && ( cp "${GOPATH}/bin/docker-credential-gcr" /usr/local/bin/docker-credential-gcr \
   || cp "${GOPATH}/bin/${TARGETOS}_${TARGETARCH}/docker-credential-gcr" /usr/local/bin/docker-credential-gcr )

FROM ${REGISTRY}/library/alpine:${ALPINE_VER} as release-alpine
COPY --from=build /etc/passwd /etc/group /etc/
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build --chown=appuser /home/appuser /home/appuser
COPY --from=docker-cred-ecr-login /usr/local/bin/docker-credential-* /usr/local/bin/
COPY --from=docker-cred-gcr /usr/local/bin/docker-credential-* /usr/local/bin/
COPY --from=build /src/bin/regctl /usr/local/bin/regctl
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
ADD  build/root.tgz /
COPY --from=build /etc/passwd /etc/group /etc/
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build --chown=appuser /home/appuser /home/appuser
COPY --from=build /src/bin/regctl /regctl
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