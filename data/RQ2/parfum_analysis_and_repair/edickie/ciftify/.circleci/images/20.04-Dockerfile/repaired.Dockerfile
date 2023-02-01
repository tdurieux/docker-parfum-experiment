FROM ubuntu:focal-20200720

# Prepare environment
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bc \
        ca-certificates \
        curl \
        dpkg \
        tar \
        unzip \
        wget \
        gcc \
        git \
        pkg-config \
        libpng-dev \
        libfreetype-dev \
        libncurses-dev \
        libjpeg-dev \
        gnupg \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-venv && rm -rf /var/lib/apt/lists/*;

# Get connectome-workbench
RUN wget -O- https://neuro.debian.net/lists/focal.us-ca.full >> /etc/apt/sources.list.d/neurodebian.sources.list && \
        apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9 && \
        apt update && \
        apt install --no-install-recommends -y connectome-workbench && rm -rf /var/lib/apt/lists/*;

# Get bids-validator
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && \
        apt-get install --no-install-recommends -y nodejs && \
        npm install -g bids-validator && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/bash"]
