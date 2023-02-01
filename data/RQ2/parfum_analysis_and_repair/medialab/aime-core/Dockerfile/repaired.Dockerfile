FROM node:0.12.2

ENV NODE_ENV production

COPY . /aime-core
WORKDIR /aime-core

RUN npm install && npm cache clean --force;
RUN cp config.docker.json config.json

CMD ["node", "--harmony", "/aime-core/scripts/start.js"]
