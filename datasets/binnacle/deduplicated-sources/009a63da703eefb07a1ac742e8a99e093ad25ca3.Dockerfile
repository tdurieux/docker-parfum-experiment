FROM ubuntu:16.04
ARG CNM_BUILD_DIR

# Install dependencies.
RUN apt-get update && apt-get install -y ebtables

# Create plugins directory.
RUN mkdir -p /run/docker/plugins

# Install plugin.
COPY $CNM_BUILD_DIR/azure-vnet-plugin /usr/bin
WORKDIR /usr/bin

CMD ["/usr/bin/azure-vnet-plugin"]
