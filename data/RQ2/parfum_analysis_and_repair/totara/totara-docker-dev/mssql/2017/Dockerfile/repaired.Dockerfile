# mssql-agent-fts-ha-tools
# Maintainers: Microsoft Corporation (twright-msft on GitHub)
# GitRepo: https://github.com/Microsoft/mssql-docker

# Base OS layer: Latest Ubuntu LTS
FROM ubuntu:16.04

# Install curl since it is needed to get repo config
# Get official Microsoft repository configuration
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install --no-install-recommends -y curl locales && \
    apt-get install -y --no-install-recommends apt-transport-https && \
    curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl -f https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2017.list | tee /etc/apt/sources.list.d/mssql-server.list && \
    apt-get update && rm -rf /var/lib/apt/lists/*;

# Install SQL Server which a prerequisite for the optional packages below.
# Install full text search addons
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get install --no-install-recommends -y mssql-server mssql-server-ha mssql-server-fts && rm -rf /var/lib/apt/lists/*;

# we need en_US locales for MSSQL connection to work
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN export DEBIAN_FRONTEND=noninteractive && \
    curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl -f https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/msprod.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get --no-install-recommends install -y msodbcsql mssql-tools unixodbc-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /custom
COPY custom /custom/

RUN chmod +x /custom/*.sh

# Run SQL Server process
CMD /bin/bash /custom/entrypoint.sh