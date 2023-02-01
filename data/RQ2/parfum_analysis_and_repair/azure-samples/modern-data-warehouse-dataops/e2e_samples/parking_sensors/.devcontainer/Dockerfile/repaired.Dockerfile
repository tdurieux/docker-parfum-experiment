#-----------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See LICENSE in the project root for license information.
#-----------------------------------------------------------------------------------------
FROM python:3.7-stretch

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils 2>&1 && rm -rf /var/lib/apt/lists/*;

# Install git, process tools, lsb-release (common in install instructions for CLIs)
RUN apt-get -y --no-install-recommends install git procps lsb-release && rm -rf /var/lib/apt/lists/*;

# Install any missing dependencies for enhanced language service
RUN apt-get install --no-install-recommends -y libicu[0-9][0-9] && rm -rf /var/lib/apt/lists/*;

# Install Azure CLI and application insights and azure devops extension
RUN curl -f -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN az extension add --name application-insights
RUN az extension add --name azure-devops

# Install Databricks CLI
RUN pip install --no-cache-dir databricks-cli

# Install jq & makepasswd for some frequently used utility
RUN apt-get update \
    && apt-get -y --no-install-recommends install jq makepasswd && rm -rf /var/lib/apt/lists/*;

# Install java
RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64

RUN mkdir /workspace
WORKDIR /workspace



# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog

# Set PACKAGE_VERSION to localdev
ENV PACKAGE_VERSION=localdev

# Set the default shell to bash rather than sh
ENV SHELL /bin/bash
