FROM node:12.9.0-stretch-slim

WORKDIR /code

COPY package.json yarn.lock ./

RUN yarn && \
    yarn cache clean && yarn cache clean;

COPY bsconfig.json ./
COPY ./src ./src

RUN yarn build && yarn cache clean;

ENTRYPOINT ["bash", "-c"]
CMD ["node lib/js/src/Main.bs.js"]