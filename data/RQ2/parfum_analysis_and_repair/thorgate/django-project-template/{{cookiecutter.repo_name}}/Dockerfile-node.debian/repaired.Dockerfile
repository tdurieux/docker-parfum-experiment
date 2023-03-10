FROM node:{{ cookiecutter.node_version }}-buster-slim

# Install system requirements
# Use non-interactive frontend for debconf
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install system requirements
RUN apt-get update && \
    apt-get install -y --no-install-recommends git python && \
    rm -rf /var/lib/apt/lists/*

# Set the default directory where CMD will execute
WORKDIR /app

# Set the default command to execute when creating a new container
COPY scripts/node-dev-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh", "--"]
CMD bash