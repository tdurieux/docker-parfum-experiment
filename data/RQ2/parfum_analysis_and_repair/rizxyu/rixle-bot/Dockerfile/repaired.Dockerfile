FROM node:16.13.0

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  neofetch \
  ffmpeg \
  wget \
  chromium \
  imagemagick && \
  rm -rf /var/lib/apt/lists/*

COPY package.json .
RUN npm install -g npm@latest && npm cache clean --force;
RUN npm install && npm cache clean --force;
RUN npm instal pm2 -g
RUN npm install ytdl-core@latest && npm cache clean --force;
RUN npm install yt-search@latest && npm cache clean --force;
ENV PM2_PUBLIC_KEY (isi disini)
ENV PM2_SECRET_KEY (isi disini)
COPY . .
EXPOSE 5000

CMD ["pm2-runtime", "index.js"]`
