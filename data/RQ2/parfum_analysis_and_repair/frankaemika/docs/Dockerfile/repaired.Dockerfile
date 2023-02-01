FROM franka/build/ubuntu-20.04:0.2.0
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    npm \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*
