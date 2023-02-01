FROM node:12.14
WORKDIR /user/src/app/

COPY package.json yarn.lock .
RUN yarn install && yarn cache clean;

COPY --chown=node:node . .

RUN yarn run build && yarn cache clean;

EXPOSE 5001
CMD ["yarn", "run", "start"]
