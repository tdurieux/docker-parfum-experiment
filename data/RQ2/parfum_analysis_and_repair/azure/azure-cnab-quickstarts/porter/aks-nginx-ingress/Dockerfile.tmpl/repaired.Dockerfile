FROM debian:stretch

ARG BUNDLE_DIR

# PORTER_MIXINS

RUN apt-get update && apt-get install -y --no-install-recommends gettext-base && rm -rf /var/lib/apt/lists/*;

COPY manifests/ $BUNDLE_DIR
COPY scripts/ $BUNDLE_DIR