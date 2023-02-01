FROM ubuntu:18.04

# apt-get and system utilities
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl apt-utils apt-transport-https debconf-utils gcc build-essential g++-5 \
    && rm -rf /var/lib/apt/lists/*

# Install SQL Server drivers and tools
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl -f https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get --no-install-recommends install -y msodbcsql17 \
    && ACCEPT_EULA=Y apt-get --no-install-recommends install -y mssql-tools \
    && apt-get install --no-install-recommends -y unixodbc-dev libssl1.0.0 \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/opt/mssql-tools/bin:${PATH}"

# Python 3 libraries
RUN apt-get update \
    && apt-get install --no-install-recommends -y python3-pip python3-dev \
    && cd /usr/local/bin \
    && ln -s /usr/bin/python3 python \
    && pip3 install --no-cache-dir --upgrade pip \
    && rm -rf /var/lib/apt/lists/*

# Install necessary locales
RUN apt-get update && apt-get install --no-install-recommends -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && rm -rf /var/lib/apt/lists/*
