FROM python:3.10-bullseye

# Update the apt package index.
RUN apt-get update \
    && apt-get upgrade -y

# Install CLI utils.
RUN apt-get install --no-install-recommends -y zsh \
    && sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" \
    && chsh -s $(which zsh) \
    && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Instal NPM and Node.js.
RUN apt-get install --no-install-recommends -y npm \
    && npm install -g npm@latest \
    && apt-get install --no-install-recommends -y nodejs && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# Install Home Assistant.
RUN apt-get install --no-install-recommends -y python3 \
    python3-dev python3-venv python3-pip \
    libffi-dev libssl-dev libjpeg-dev zlib1g-dev autoconf \
    build-essential libopenjp2-7 libtiff5 libturbojpeg0 tzdata \
    && python3 -m pip install wheel \
    && pip3 install --no-cache-dir homeassistant \
    && mkdir -p /config \
    && ln -sf "/workspaces/uptime-card/.devcontainer/configuration.yaml" /config/configuration.yaml \
    && ln -sf "/workspaces/uptime-card/.devcontainer/ui-lovelace.yaml" /config/ui-lovelace.yaml && rm -rf /var/lib/apt/lists/*;
