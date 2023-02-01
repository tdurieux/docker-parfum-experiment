#-----------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See LICENSE in the project root for license information.
#-----------------------------------------------------------------------------------------

FROM python:3.7.3

# Copy default endpoint specific user settings overrides into container to specify Python path
COPY .devcontainer/settings.vscode.json /root/.vscode-remote/data/Machine/settings.json

# Install pylint
RUN pip install --no-cache-dir pylint

# Install git, process tools
RUN apt-get update && apt-get -y --no-install-recommends install git procps && rm -rf /var/lib/apt/lists/*;

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install --no-install-recommends -y openjdk-8-jdk && \
    apt-get install --no-install-recommends -y ant && \
    apt-get clean; rm -rf /var/lib/apt/lists/*;


ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# Install any missing dependencies for enhanced language service
RUN apt-get install --no-install-recommends -y libicu[0-9][0-9] && rm -rf /var/lib/apt/lists/*;

RUN mkdir /workspace
WORKDIR /workspace

# Install Python dependencies from requirements.txt if it exists
COPY ./requirements.txt requirements.txt* /workspace/
RUN if [ -f "requirements.txt" ]; then \
 pip install --no-cache-dir -r requirements.txt && rm requirements.txt*; fi

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
