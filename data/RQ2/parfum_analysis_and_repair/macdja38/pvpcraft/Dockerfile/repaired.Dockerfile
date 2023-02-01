FROM node:16

MAINTAINER macdja38

RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev && apt-get clean; rm -rf /var/lib/apt/lists/*;

RUN npm install -g pm2 && npm cache clean --force;

RUN mkdir -p /docker/pvpcraft/pvpcraft

WORKDIR /docker/pvpcraft/pvpcraft/

ADD package*.json /docker/pvpcraft/pvpcraft/

RUN npm install && npm cache clean --force;

ADD . /docker/pvpcraft/pvpcraft/

RUN git config --unset http.https://github.com/.extraheader && npm run build

CMD ["pm2-docker", "pm2.json"]
