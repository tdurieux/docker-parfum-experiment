# Use a minimal image as a parent image
FROM ubuntu:18.04
ARG NPM_BUILD_DIR

# Install dependencies.
RUN apt-get update
RUN apt-get install -y iptables
RUN apt-get install -y ipset

# Install plugin.
COPY $NPM_BUILD_DIR/azure-npm /usr/bin

WORKDIR /usr/bin

# Run the npm command by default when the container starts.
ENTRYPOINT ["/usr/bin/azure-npm"]