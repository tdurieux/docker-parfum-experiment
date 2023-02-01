from node:16-alpine

WORKDIR /usr/src/app

RUN npm install -g serverless && npm cache clean --force;

COPY package.json .

RUN npm install && npm cache clean --force;

COPY . ./

CMD [ "serverless", "offline" ]
