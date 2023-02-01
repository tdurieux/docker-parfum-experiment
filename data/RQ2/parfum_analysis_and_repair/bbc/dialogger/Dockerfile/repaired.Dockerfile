FROM node:boron

RUN mkdir -p /usr/src/dialogger && rm -rf /usr/src/dialogger
WORKDIR /usr/src/dialogger

RUN apt-get update && apt-get install --no-install-recommends -y mediainfo && rm -rf /var/lib/apt/lists/*;
RUN npm install -g gulp bower bunyan && npm cache clean --force;

COPY package.json semantic.json /usr/src/dialogger/
RUN npm install && npm cache clean --force;

COPY bower.json .bowerrc /usr/src/dialogger/
RUN npm run build

COPY . /usr/src/dialogger

EXPOSE 8080
CMD ["npm", "start"]
