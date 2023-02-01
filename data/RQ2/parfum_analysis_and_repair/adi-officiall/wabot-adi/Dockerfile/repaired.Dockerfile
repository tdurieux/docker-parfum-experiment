FROM node:16.10.0-buster

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  neofetch \
  chromium \
  ffmpeg \
  wget \
  imagemagick \
  graphicsmagick \
  webp \
  mc && \
  rm -rf /var/lib/apt/lists/*

COPY package.json .
RUN npm install -g npm@8.1.3 && npm cache clean --force;
RUN npm install -g pm2 && npm cache clean --force;
RUN npm update
COPY . .
RUN pm2 save
CMD ["pm2-runtime", "index.js"]`
