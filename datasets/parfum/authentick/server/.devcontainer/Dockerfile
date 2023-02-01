FROM mcr.microsoft.com/dotnet/sdk:5.0

RUN apt-get update && apt-get install -y \
       gnupg \
    && curl -sL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && echo "deb https://deb.nodesource.com/node_13.x buster main" | tee /etc/apt/sources.list.d/nodesource.list \
    && echo "deb-src https://deb.nodesource.com/node_13.x buster main" | tee -a /etc/apt/sources.list.d/nodesource.list \
    && apt-get update && apt-get install -y \
       vim \
       nodejs \
       zsh \
       iputils-ping \
       dnsutils \
       telnet \
       netcat \
       procps \
       lsof \
       apt-transport-https \
       ca-certificates \
       curl \
       gnupg-agent \
       software-properties-common \
       htop \
       ldap-utils \
       tcpdump \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && if [ "$(uname -m)" = 'x86_64' ]; then \
        add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable"; \
       else \
        add-apt-repository \
        "deb [arch=arm64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable"; \
       fi \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io \
    && ln -s /var/run/docker-host.sock /var/run/docker.sock  \
    && npm install --global gulp-cli \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && dotnet tool install --global dotnet-ef --version 5.0.3 \
    && dotnet tool install --global dotnet-format \
    && dotnet tool install --global dotnet-aspnet-codegenerator --version 5.0.2 \
    && echo "export PATH=\"$PATH:/root/.dotnet/tools\"" >> ~/.bash_profile \
    && rm -rf /var/lib/apt/lists/*
