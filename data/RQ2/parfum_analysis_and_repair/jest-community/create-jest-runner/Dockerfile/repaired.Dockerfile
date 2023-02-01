ARG NODE_VERSION=8
FROM node:${NODE_VERSION}

WORKDIR /app

COPY package.json yarn.lock /app/

RUN yarn --ignore-scripts && yarn cache clean;

COPY . .

RUN yarn build && yarn cache clean;

CMD ["yarn", "test"]