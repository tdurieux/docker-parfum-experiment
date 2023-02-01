FROM node:16

COPY package.json /
COPY yarn.lock /

RUN yarn && yarn cache clean;

COPY src/*.ts /
COPY tsconfig.json /

RUN ["yarn", "build"]

ENTRYPOINT ["node", "/index.js"]
