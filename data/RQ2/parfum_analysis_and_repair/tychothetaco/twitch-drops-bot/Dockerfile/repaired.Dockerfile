FROM node:current-bullseye

# Install Chromium
RUN apt-get update && apt-get install --no-install-recommends chromium -y && rm -rf /var/lib/apt/lists/*;

# Copy required files
WORKDIR /app
COPY ./src ./src
COPY package*.json ./
COPY tsconfig.json ./

# Don't download the bundled Chromium with Puppeteer (It doesn't have the required video codecs to play Twitch video streams)
ENV PUPPETEER_SKIP_DOWNLOAD=true

# Install dependencies
RUN npm install && npm cache clean --force;

# Compile the app
RUN npm run compile

WORKDIR /app/data

ARG GIT_COMMIT_HASH=""

ENV GIT_COMMIT_HASH=${GIT_COMMIT_HASH}

ENTRYPOINT ["node", "--unhandled-rejections=strict", "/app/dist/index.js"]
