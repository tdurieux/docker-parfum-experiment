FROM node:14-slim
LABEL maintainer="xfileFIN"
WORKDIR /src

COPY package.json /src/package.json
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg libtool autoconf automake make g++ python3 && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN npm install

COPY . /src

CMD npm start
