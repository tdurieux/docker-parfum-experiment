FROM node:latest

WORKDIR /app
COPY package.json /app/
RUN npm install -g bower && npm cache clean --force;
RUN npm install --production && npm cache clean --force;
COPY . /app

CMD []
ENTRYPOINT ["node", "server"]
