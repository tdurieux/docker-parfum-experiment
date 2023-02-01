FROM node:12
WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn --frozen-lockfile && yarn cache clean;
COPY . ./
RUN yarn build && yarn cache clean;
EXPOSE 3000
CMD yarn start
