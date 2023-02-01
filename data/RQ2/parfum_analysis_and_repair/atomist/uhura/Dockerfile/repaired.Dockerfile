FROM atomist/sdm-base:0.2.0

# Install yarn
RUN npm install --global yarn && npm cache clean --force;

# Install .NET Core tools
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get install --no-install-recommends -y apt-transport-https \
    && apt-get update \
    && apt-get install --no-install-recommends -y dotnet-sdk-2.2 && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
        openjdk-8-jdk-headless maven \
        libfontconfig \
    && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./

RUN npm ci \
    && npm cache clean --force

COPY . .
