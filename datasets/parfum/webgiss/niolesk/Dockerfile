ARG SOURCE=local
ARG IMAGE_BUILD=node:16-alpine3.14

#----------------------------------------

FROM ${IMAGE_BUILD} as builder-base

RUN \
    apk update && \
    apk add git

#----------------------------------------

FROM builder-base as builder-git

ARG REPO=https://github.com/webgiss/niolesk
ARG POINT=main

RUN \
    git clone "${REPO}" /app && \
    cd /app && \
    git checkout "${POINT}"

#----------------------------------------

FROM builder-base as builder-local

ARG PUBLIC_URL=/

ADD . /app

FROM builder-${SOURCE} as builder

RUN \
    cd /app && \
    yarn && \
    yarn create-example-cache && \
    PUBLIC_URL=${PUBLIC_URL} yarn build

#----------------------------------------

FROM nginx:alpine

ARG VCS_REF=working-copy
ARG BUILD_DATE=now
ARG VERSION=dev

LABEL \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.authors="gissehel" \
      org.opencontainers.image.url="https://github.com/webgiss/niolesk" \
      org.opencontainers.image.source="https://github.com/webgiss/niolesk" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.vendor="gissehel" \
      org.opencontainers.image.ref.name="ghcr.io/webgiss/niolesk" \
      org.opencontainers.image.title="niolesk" \
      org.opencontainers.image.description="Image for niolesk" \
      org.label-schema.build-date="${BUILD_DATE}" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.name="niolesk" \
      org.label-schema.version="${VERSION}" \
      org.label-schema.vendor="gissehel" \
      org.label-schema.vcs-url="https://github.com/webgiss/niolesk" \
      org.label-schema.schema-version="1.0" \
      maintainer="Gissehel <public-maintainer-docker-niolesk@gissehel.org>"

COPY --from=builder /app/docker-res/update-config.sh /docker-entrypoint.d/update-config.sh
COPY --from=builder /app/build/ /usr/share/nginx/html/
