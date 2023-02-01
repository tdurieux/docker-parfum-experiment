FROM node:14.17.0

WORKDIR /polygon/core

COPY . .

RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;

EXPOSE 3001

CMD ["yarn", "start"]
