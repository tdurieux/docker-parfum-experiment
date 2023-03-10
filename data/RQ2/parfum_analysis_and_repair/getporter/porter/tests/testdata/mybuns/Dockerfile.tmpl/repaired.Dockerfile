FROM debian:stretch-slim

ARG BUNDLE_DIR

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt--mount=type=cache,target=/var/lib/apt \
    apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

ENV CUSTOM_VAR=boop
ENV USERNAME=root

# PORTER_MIXINS

# Use the BUNDLE_DIR build argument to copy files into the bundle
COPY --link . ${BUNDLE_DIR}
