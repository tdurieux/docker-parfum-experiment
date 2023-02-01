# Stage 1 - Build elixir release of ockam_cloud_node elixir app
FROM ghcr.io/build-trust/ockam-builder@sha256:d560cb1ed32124e68cb4dc5fc2902240090f122864715756ace06e99e38e6cb2 as elixir-app-release-build
COPY . /work
RUN set -xe; \
    cd implementations/elixir; \
    ../../gradlew build; \
    cd ockam/ockam_cloud_node; \
    MIX_ENV=prod mix release;


# TODO: Use distroless container after https://github.com/elixir-lang/elixir/issues/11942 is closed
# Stage 2 - Create container and copy executables in above step