FROM node:12
WORKDIR /app
COPY package.json /app
COPY package-lock.json /app
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python2.7 python-pip && rm -rf /var/lib/apt/lists/*;
RUN npm install && npm cache clean --force;
RUN npm update ytdl-core
COPY . /app
WORKDIR /src
CMD ["node", "index.js"]