FROM node:carbon

COPY package.json .
COPY yarn.lock .

RUN yarn install && yarn cache clean;

COPY . .

RUN ./node_modules/.bin/tsc -p tsconfig.json

CMD [ "yarn", "start" ]