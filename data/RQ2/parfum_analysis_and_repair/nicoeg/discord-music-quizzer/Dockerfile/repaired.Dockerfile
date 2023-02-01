FROM node:12.18.4-stretch

WORKDIR /app

RUN apt-get update && \
    apt install --no-install-recommends -y ffmpeg libav-tools opus-tools && rm -rf /var/lib/apt/lists/*;

COPY ./ /app

RUN npm ci && \
    npm run build

ENTRYPOINT ["node", "dist/index.js"]
