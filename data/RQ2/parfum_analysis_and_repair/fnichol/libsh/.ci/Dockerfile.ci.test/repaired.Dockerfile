ARG VERSION=20190328

FROM busybox:1.30.1 as bb30
FROM busybox:1.23.2 as bb23

FROM fidian/multishell:$VERSION

ARG VERSION

COPY --from=bb30 /bin/busybox /usr/local/bin/busybox-1.30.1
COPY --from=bb23 /bin/busybox /usr/local/bin/busybox-1.23.2

# hadolint ignore=DL3008
RUN apt-get update -y \
  && apt-get install --no-install-recommends -y \
    busybox \
    ca-certificates \
    curl \
    git \
    make \
    tar \
  && apt-get clean \
  && rm -rf /var/lib/lists/* \
  && for v in 1.30.1 1.23.2; do \
      for s in ash hush; do \
        echo '#!/usr/bin/env sh' >"/usr/local/bin/busybox-${v}-${s}"; \
        echo "exec /usr/local/bin/busybox-$v $s \"\$@\"" \
          >>"/usr/local/bin/busybox-${v}-${s}"; \
        chmod 0755 "/usr/local/bin/busybox-${v}-${s}"; \
      done; \
    done && rm -rf /var/lib/apt/lists/*;
