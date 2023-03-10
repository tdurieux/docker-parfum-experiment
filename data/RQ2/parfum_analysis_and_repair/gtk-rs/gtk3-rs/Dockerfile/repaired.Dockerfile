FROM ubuntu:20.10

RUN apt update -y && apt install --no-install-recommends -y \
    libgtk-3-dev \
    libglib2.0-dev \
    libgraphene-1.0-dev \
    git \
    xvfb \
    curl \
    libcairo-gobject2 \
    libcairo2-dev \
    wget && rm -rf /var/lib/apt/lists/*;
