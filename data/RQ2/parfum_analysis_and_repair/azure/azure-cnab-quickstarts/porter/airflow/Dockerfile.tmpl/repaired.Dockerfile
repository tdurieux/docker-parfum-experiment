FROM debian:stretch

ARG BUNDLE_DIR

COPY . $BUNDLE_DIR

RUN apt-get update && apt-get install -y --no-install-recommends gettext-base && rm -rf /var/lib/apt/lists/*;