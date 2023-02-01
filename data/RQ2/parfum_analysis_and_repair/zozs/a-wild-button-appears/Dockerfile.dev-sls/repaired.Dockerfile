FROM node:12

RUN npm i -g serverless && npm cache clean --force;

USER node
RUN mkdir /home/node/app
WORKDIR /home/node/app

COPY package*json ./
RUN npm i && npm cache clean --force;

CMD [ "sls", "offline", "start" ]
