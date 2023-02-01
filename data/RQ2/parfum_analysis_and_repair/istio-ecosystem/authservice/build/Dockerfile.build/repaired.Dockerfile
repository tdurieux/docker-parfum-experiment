# The docker image for the actual build process.
# Copy in only the necessary files for building.
FROM ghcr.io/istio-ecosystem/authservice/authservice-build-env:2021-11-26 as auth-builder
COPY . /src/

# Build auth binary.
ARG bazel_flags=""
WORKDIR /src
RUN bash ./bazel/setup_clang.sh /usr/lib/llvm-12/
RUN BAZEL_FLAGS=$bazel_flags make bazel-bin/src/main/auth_server

# Create our final auth-server container image.
FROM debian:buster
RUN groupadd -r auth-server-grp && useradd -m -g auth-server-grp auth-server-usr

# Install dependencies