FROM node:current

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install packages
# hadolint ignore=DL3008,DL3009,SC2086
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        gnupg-agent \
        libssl-dev \
        software-properties-common \
        wget \
        zsh \
    && apt-get clean \
    && curl -f -o- "https://get.docker.com" | bash \
    && curl -f -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && curl -f -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && rm -rf /var/lib/apt/lists/*;

# Set the default shell to zsh
ENV SHELL /bin/zsh

# Copy zshrc with plugin config
COPY .devcontainer/.zshrc /root/.zshrc

WORKDIR /workspaces
