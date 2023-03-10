FROM alpine:3.13

WORKDIR /home/flux

RUN apk add --no-cache openssh-client ca-certificates tini 'git>=2.12.0' socat curl bash

# Add git hosts to known hosts file so we can use
# StrickHostKeyChecking with git+ssh
ADD ./known_hosts.sh /home/flux/known_hosts.sh
RUN sh /home/flux/known_hosts.sh /etc/ssh/ssh_known_hosts && \
    rm /home/flux/known_hosts.sh

# Add default SSH config, which points at the private key we'll mount
COPY ./ssh_config /etc/ssh/ssh_config

COPY ./kubectl /usr/local/bin/
# The Helm clients are included as a convenience for troubleshooting
COPY ./helm2 /usr/local/bin/
COPY ./helm3 /usr/local/bin/

# These are pretty static
LABEL maintainer="Flux CD <https://github.com/fluxcd/helm-operator/issues>" \
      org.opencontainers.image.title="helm-operator" \
      org.opencontainers.image.description="The Helm operator for Kubernetes" \
      org.opencontainers.image.url="https://github.com/fluxcd/helm-operator" \
      org.opencontainers.image.source="git@github.com:fluxcd/helm-operator" \
      org.opencontainers.image.vendor="Flux CD" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="helm-operator" \
      org.label-schema.description="The Helm operator for Kubernetes" \
      org.label-schema.url="https://github.com/fluxcd/helm-operator" \
      org.label-schema.vcs-url="git@github.com:fluxcd/helm-operator" \
      org.label-schema.vendor="Flux CD"

ENTRYPOINT [ "/sbin/tini", "--", "helm-operator" ]

ENV HELM_HOME=/var/fluxd/helm
COPY ./helm-repositories.yaml /var/fluxd/helm/repository/repositories.yaml
RUN mkdir -p /var/fluxd/helm/repository/cache/

COPY ./helm-operator /usr/local/bin/

ARG BUILD_DATE
ARG VCS_REF

# These will change for every build
LABEL org.opencontainers.image.revision="$VCS_REF" \
      org.opencontainers.image.created="$BUILD_DATE" \
      org.label-schema.vcs-ref="$VCS_REF" \
      org.label-schema.build-date="$BUILD_DATE"