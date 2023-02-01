FROM node:17-bullseye

RUN apt-get -y update
RUN apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y imagemagick && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app

COPY package*.json ./
COPY tsconfig.json ./
COPY babel.config.js ./
COPY src ./src

RUN npm install && npm cache clean --force;
RUN npm run build

CMD [ "node", "build/ctrl.js" ]
