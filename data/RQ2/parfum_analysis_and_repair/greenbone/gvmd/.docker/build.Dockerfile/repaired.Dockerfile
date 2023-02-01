# Define ARG we use through the build
ARG VERSION=unstable

# We want gvm-libs to be ready so we use the build docker image of gvm-libs
FROM greenbone/gvm-libs:$VERSION

# This will make apt-get install without question
ARG DEBIAN_FRONTEND=noninteractive

# Redefine ARG we use through the build
ARG VERSION

WORKDIR /usr/local/src

# Install Debian core dependencies required for building gvm with PostgreSQL
# support and not yet installed as dependencies of gvm-libs-core