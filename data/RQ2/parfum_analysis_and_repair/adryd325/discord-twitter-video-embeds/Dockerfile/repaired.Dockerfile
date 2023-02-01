FROM node:16-bullseye

RUN sed -i "s:^deb http://ftp.debian.org/debian ([^\s]*) main contrib$:deb http://ftp.debian.org/debian ([^\s]*) main contrib backports:g" /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg git sudo gcc g++ make yt-dlp && rm -rf /var/lib/apt/lists/*;
RUN npm install -g pnpm && npm cache clean --force;

RUN mkdir -p /bot
WORKDIR /bot

# Add just what's necessary to install modules first, for caching purposes
COPY package.json /bot/package.json
COPY pnpm-lock.yaml /bot/pnpm-lock.yaml
RUN pnpm i -C /bot

ADD . /bot

CMD bash -l -c "node index.js"
