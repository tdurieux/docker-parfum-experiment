FROM ubuntu:20.04

ARG NODEJS_VERSION=14
ARG POSTGRES_VERSION=12

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    curl && rm -rf /var/lib/apt/lists/*;

# Install postgres client tools
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    postgresql-client-${POSTGRES_VERSION} && rm -rf /var/lib/apt/lists/*;

# Install nodejs via nodesource.
RUN curl -fsSL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Latest version of graphile-migrate
RUN npm install -g graphile-migrate && npm cache clean --force;

# Default working directory. Map your migrations folder in here with `docker -v`
WORKDIR /migrate

ENTRYPOINT ["/usr/bin/graphile-migrate"]
