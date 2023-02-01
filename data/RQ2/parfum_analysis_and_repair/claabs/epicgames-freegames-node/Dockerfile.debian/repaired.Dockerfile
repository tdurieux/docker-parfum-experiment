########
# BASE
########
FROM node:16-bullseye-slim as base

ENV DISTRO=debian
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1

WORKDIR /usr/app

########
# DEPS
########
FROM base as deps

# Chromium dependencies https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#running-puppeteer-in-docker
# The Google Chrome apt list only seems to provide the latest version, so version compatibility with puppeteer is questionable
RUN apt-get update \
    && apt-get install --no-install-recommends -y wget gnupg procps \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    google-chrome-stable \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-thai-tlwg \
    fonts-kacst \
    fonts-freefont-ttf \
    libxss1 \
    # App dependencies
    jq \
    tzdata \
    cron \
    tini \
    && rm -rf /var/lib/apt/lists/*

########
# BUILD
########
FROM base as build

# Copy all source files
COPY package*.json tsconfig.json ./

# Add dev deps
RUN npm ci

# Copy source code
COPY src src

RUN npm run build

########
# DEPLOY
########
FROM deps as deploy

# Copy package.json for version number
COPY package*.json ./

RUN npm ci --only=production

# Steal compiled code from build image
COPY --from=build /usr/app/dist ./dist

COPY entrypoint.sh /usr/local/bin/docker-entrypoint.sh
# backwards compat (from https://success.docker.com/article/use-a-script-to-initialize-stateful-container-data)
RUN ln -s /usr/local/bin/docker-entrypoint.sh /

ARG COMMIT_SHA="" \
    BRANCH=""

LABEL org.opencontainers.image.title="epicgames-freegames-node" \ 
    org.opencontainers.image.url="https://github.com/claabs/epicgames-freegames-node" \
    org.opencontainers.image.description="Automatically redeem free games promotions on the Epic Games store" \
    org.opencontainers.image.name="epicgames-freegames-node" \
    org.opencontainers.image.revision=${COMMIT_SHA} \
    org.opencontainers.image.ref.name=${BRANCH} \
    org.opencontainers.image.base.name="node:16-bullseye-slim" \
    org.opencontainers.image.version="bullseye-slim"

ENV NODE_ENV=production \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable \
    COMMIT_SHA=${COMMIT_SHA} \
    BRANCH=${BRANCH}

EXPOSE 3000

VOLUME [ "/usr/app/config" ]

ENTRYPOINT ["tini", "--", "docker-entrypoint.sh"]
