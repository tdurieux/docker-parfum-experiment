FROM node:14

WORKDIR /chatcola

VOLUME [ '/home/' ]

COPY package.json yarn.lock ./

RUN yarn install && yarn cache clean;

COPY . .

RUN chmod +x ./scripts/build
RUN ./scripts/build

RUN npm install -g pm2 && npm cache clean --force;

ENV NODE_ENV=${NODE_ENV:-production}

CMD [ "pm2-runtime", "build/drivers/p2p/index.js" ]