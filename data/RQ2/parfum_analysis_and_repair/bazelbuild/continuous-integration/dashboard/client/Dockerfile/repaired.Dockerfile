FROM node:14-alpine
WORKDIR /app

# Install app dependencies
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;

# Build app
COPY . ./
RUN yarn build && yarn cache clean;

ENTRYPOINT ["yarn", "start"]