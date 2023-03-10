FROM ALPINE_BASEIMAGE

# These labels are pretty static, and can therefore be added early on:
LABEL works.weave.role="system" \
      maintainer="Weaveworks <help@weave.works>" \
      org.opencontainers.image.title="Weave Net" \
      org.opencontainers.image.description="Weave Net creates a virtual network that connects Docker containers across multiple hosts and enables their automatic discovery" \
      org.opencontainers.image.url="https://weave.works" \
      org.opencontainers.image.source="https://github.com/weaveworks/weave" \
      org.opencontainers.image.vendor="Weaveworks" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="Weave Net" \
      org.label-schema.description="Weave Net creates a virtual network that connects Docker containers across multiple hosts and enables their automatic discovery" \
      org.label-schema.url="https://weave.works" \
      org.label-schema.vcs-url="https://github.com/weaveworks/weave" \
      org.label-schema.vendor="Weaveworks"

# If we're building for another architecture than amd64, the CROSS_BUILD_ placeholder is removed so e.g. CROSS_BUILD_COPY turns into COPY
# If we're building normally, for amd64, CROSS_BUILD lines are removed
CROSS_BUILD_COPY qemu-QEMUARCH-static /usr/bin/

RUN apk add --no-cache --update \
    curl \
    iptables \
    ipset \
    iproute2 \
    conntrack-tools \
    bind-tools \
    ca-certificates \
  && rm -rf /var/cache/apk/*

ADD ./weave ./weaver /home/weave/
ADD ./weaveutil /usr/bin/
ADD weavedata.db /weavedb/
ENTRYPOINT ["/home/weave/weaver"]
WORKDIR /home/weave

# These labels will change for every build, and should therefore be the last layer of the image:
ARG revision
LABEL org.opencontainers.image.revision="${revision}" \
      org.label-schema.vcs-ref="${revision}"
