FROM node:12

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
COPY api/package.json api/tsconfig.json ./api/
COPY client/package.json client/tsconfig.json ./client/

RUN yarn && yarn cache clean;

COPY . .

EXPOSE 7878

RUN GENERATE_SOURCEMAP=false yarn build && yarn cache clean;

CMD [ "node", "./api/dist/index.js" ]
