FROM alpine:3.15

WORKDIR /home/flux

RUN apk add --no-cache openssh-client ca-certificates curl

COPY ./fluxctl /usr/local/bin/

LABEL maintainer="Flux CD <https://github.com/fluxcd/flux/issues>" \
      org.opencontainers.image.title="fluxctl" \
      org.opencontainers.image.description="Flux CLI" \
      org.opencontainers.image.url="https://github.com/fluxcd/flux" \
      org.opencontainers.image.source="git@github.com:fluxcd/flux" \
      org.opencontainers.image.vendor="Flux CD" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="fluxctl" \
      org.label-schema.description="Flux CLI" \
      org.label-schema.url="https://github.com/fluxcd/flux" \
      org.label-schema.vcs-url="git@github.com:fluxcd/flux" \
      org.label-schema.vendor="Flux CD"

ARG BUILD_DATE
ARG VCS_REF

LABEL org.opencontainers.image.revision="$VCS_REF" \
      org.opencontainers.image.created="$BUILD_DATE" \
      org.label-schema.vcs-ref="$VCS_REF" \
      org.label-schema.build-date="$BUILD_DATE"