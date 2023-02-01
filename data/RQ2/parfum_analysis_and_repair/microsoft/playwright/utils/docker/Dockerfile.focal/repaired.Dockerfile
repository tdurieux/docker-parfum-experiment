FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=America/Los_Angeles
ARG DOCKER_IMAGE_NAME_TEMPLATE="mcr.microsoft.com/playwright:v%version%-focal"

# === INSTALL Node.js ===

RUN apt-get update && \
    # Install node16
    apt-get install --no-install-recommends -y curl wget && \
    curl -f -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    # Feature-parity with node.js base images.
    apt-get install -y --no-install-recommends git openssh-client && \
    npm install -g yarn && \
    # clean apt cache
    rm -rf /var/lib/apt/lists/* && \
    # Create the pwuser
    adduser pwuser && npm cache clean --force;

# === BAKE BROWSERS INTO IMAGE ===

ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# 1. Add tip-of-tree Playwright package to install its browsers.
#    The package should be built beforehand from tip-of-tree Playwright.
COPY ./playwright-core.tar.gz /tmp/playwright-core.tar.gz

# 2. Bake in browsers & deps.
#    Browsers will be downloaded in `/ms-playwright`.
#    Note: make sure to set 777 to the registry so that any user can access
#    registry.
RUN mkdir /ms-playwright && \
    mkdir /ms-playwright-agent && \
    cd /ms-playwright-agent && npm init -y && \
    npm i /tmp/playwright-core.tar.gz && \
    npx playwright mark-docker-image "${DOCKER_IMAGE_NAME_TEMPLATE}" && \
    npx playwright install --with-deps && rm -rf /var/lib/apt/lists/* && \
    rm /tmp/playwright-core.tar.gz && \
    rm -rf /ms-playwright-agent && \
    chmod -R 777 /ms-playwright && npm cache clean --force;
