FROM node:12-stretch
COPY ./toxy/index.js ./toxy/package.json ./
RUN yarn
ENTRYPOINT yarn start