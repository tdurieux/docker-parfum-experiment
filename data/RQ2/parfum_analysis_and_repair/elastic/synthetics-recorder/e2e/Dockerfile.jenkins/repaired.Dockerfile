FROM ubuntu:20.04

# Setting bash as the default shell
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Get desired XVFB display
ARG DISPLAY

# Install dependencies before we actually
# switch into the unprivileged jenkins user.
RUN apt-get -qq update
RUN apt-get -y --no-install-recommends -qq install curl git && rm -rf /var/lib/apt/lists/*;

# Installing XVFB and other GUI-related deps for E2E tests
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y -qq install xvfb \
    libgtk-3-0 \
    libxtst6 \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    libgbm-dev \
    --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# Make relevant environment variables available for tests
ENV DISPLAY $DISPLAY
ENV NPM_COMMAND ci

WORKDIR /synthetics-recorder

# Copy .nvmrc as long as you run the script in .ci/scripts/docker-build.sh
ADD .nvmrc /synthetics-recorder/.nvmrc

# Installing NVM
ENV NVM_DIR /root
RUN curl -f -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
RUN source "${NVM_DIR}/nvm.sh" --install \
  && nvm use
