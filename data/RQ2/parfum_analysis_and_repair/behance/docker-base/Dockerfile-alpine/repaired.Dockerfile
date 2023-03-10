################################################################################
# The AlpineOS flavor is DEPRECATED and will be removed in a future release
# Please stop using this variant and use the Ubuntu flavor instead
################################################################################
FROM alpine:3.15 as base

### Stage 1 - add/remove packages ###

# Ensure scripts are available for use in next command
COPY ./container/root/scripts/* /scripts/
COPY ./container/root/usr/local/bin/* /usr/local/bin/

# - Symlink variant-specific scripts to default location
# - Add additional repositories to pull packages from
# - Add S6 for zombie reaping, boot-time coordination, signal transformation/distribution: @see https://github.com/just-containers/s6-overlay#known-issues-and-workarounds
# - Add goss for local, serverspec-like testing
RUN ln -s /scripts/clean_alpine.sh /clean.sh && \
    echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
        sed \
        bash \
        grep \
        curl \
        gnupg \
    && \
    /bin/bash -e /scripts/install_s6.sh && \
    /bin/bash -e /scripts/install_goss.sh && \
    # https://github.com/gliderlabs/docker-alpine/issues/11#issuecomment-106233554
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' > /etc/nsswitch.conf && \
    apk del \
        curl \
        gnupg \
    && \
    /bin/bash -e /clean.sh

# Overlay the root filesystem from this repo
COPY ./container/root /


### Stage 2 --- collapse layers ###

FROM scratch
COPY --from=base / .

# Use in multi-phase builds, when an init process requests for the container to gracefully exit, so that it may be committed
# Used with alternative CMD (worker.sh), leverages supervisor to maintain long-running processes
ENV SIGNAL_BUILD_STOP=99 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_KILL_FINISH_MAXTIME=5000 \
    S6_KILL_GRACETIME=3000

RUN goss -g goss.base.yaml validate

# NOTE: intentionally NOT using s6 init as the entrypoint
# This would prevent container debugging if any of those service crash