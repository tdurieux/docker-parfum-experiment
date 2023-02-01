FROM node:17
WORKDIR /workspace
COPY ./package.json ./yarn.lock ./
RUN yarn && yarn cache clean;
COPY ./*.ts ./tsconfig.json ./
RUN yarn build && yarn cache clean;
ENTRYPOINT ["node", "index.js"]
