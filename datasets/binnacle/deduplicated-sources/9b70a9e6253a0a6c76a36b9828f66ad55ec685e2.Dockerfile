FROM alpine:3.9

WORKDIR /home/flux

RUN apk add --no-cache openssh-client ca-certificates tini 'git>=2.12.0'

# Add git hosts to known hosts file so we can use
# StrickHostKeyChecking with git+ssh
ADD ./known_hosts.sh /home/flux/known_hosts.sh
RUN sh /home/flux/known_hosts.sh /etc/ssh/ssh_known_hosts && \
    rm /home/flux/known_hosts.sh

# Add default SSH config, which points at the private key we'll mount
COPY ./ssh_config /etc/ssh/ssh_config

COPY ./kubectl /usr/local/bin/
# The Helm client is included as a convenience for troubleshooting
COPY ./helm /usr/local/bin/

# These are pretty static
LABEL maintainer="Weaveworks <help@weave.works>" \
      org.opencontainers.image.title="flux-helm-operator" \
      org.opencontainers.image.description="The Flux Helm operator, for releasing Helm charts according to git" \
      org.opencontainers.image.url="https://github.com/weaveworks/flux" \
      org.opencontainers.image.source="git@github.com:weaveworks/flux" \
      org.opencontainers.image.vendor="Weaveworks" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="flux-helm-operator" \
      org.label-schema.description="The Flux Helm operator, for releasing Helm charts according to git" \
      org.label-schema.url="https://github.com/weaveworks/flux" \
      org.label-schema.vcs-url="git@github.com:weaveworks/flux" \
      org.label-schema.vendor="Weaveworks"

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
