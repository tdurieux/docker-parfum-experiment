# Build stage
FROM dev-test/raspiadk-base as build

WORKDIR /build

# Only package the build image. The built image won't have any test artifacts in it