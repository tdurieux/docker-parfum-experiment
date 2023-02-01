FROM node:14

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    build-essential \
    jq \
    libcairo2-dev \
    libgif-dev \
    libjpeg-dev \
    libpango1.0-dev \
    librsvg2-dev \
    zsh \
  && rm -rf /var/lib/apt/lists/*
