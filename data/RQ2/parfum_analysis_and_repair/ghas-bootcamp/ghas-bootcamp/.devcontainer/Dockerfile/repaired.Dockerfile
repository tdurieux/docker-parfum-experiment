FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -yq update && apt-get -yq upgrade
RUN apt-get -yq --no-install-recommends install unzip git curl apt-transport-https build-essential sudo && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://golang.org/dl/go1.15.3.linux-amd64.tar.gz --output go1.15.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.15.3.linux-amd64.tar.gz && rm go1.15.3.linux-amd64.tar.gz
RUN curl -f -sL https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb --output packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt-get -yq --no-install-recommends install nodejs python3 python3-pip python3-venv dotnet-sdk-3.1 && rm -rf /var/lib/apt/lists/*;

RUN useradd -ms /bin/bash developer

RUN npm install -g @vue/cli && npm cache clean --force;
RUN dotnet new -i IdentityServer4.Templates
