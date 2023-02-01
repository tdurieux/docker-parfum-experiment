FROM ubuntu:focal-20200720

ARG DEBIAN_FRONTEND=noninteractive

# Prepare environment
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    gnupg \
    curl \
    pkg-config \
    gcc \
    g++ \
    libfreetype-dev \
    libpng-dev \
    libopenblas-dev \
    liblapack-dev \
    libjpeg-dev \
    gfortran \
    git \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev && rm -rf /var/lib/apt/lists/*;

# Get connectome-workbench
RUN wget -O- https://neuro.debian.net/lists/focal.us-ca.full >> /etc/apt/sources.list.d/neurodebian.sources.list && \
        apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9 && \
        apt update && \
        apt install --no-install-recommends -y connectome-workbench=1.4.2-1build1 && rm -rf /var/lib/apt/lists/*;

# Get bids-validator
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && \
        apt-get install --no-install-recommends -y nodejs && \
        npm install -g bids-validator && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# Ensure pip is a reference to pip3 + update to latest version
RUN ln -s /usr/bin/pip3 /usr/bin/pip && \
        pip install --no-cache-dir --upgrade pip

CMD ["/bin/bash"]
