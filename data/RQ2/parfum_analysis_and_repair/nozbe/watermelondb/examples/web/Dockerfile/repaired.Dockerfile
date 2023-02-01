FROM mhart/alpine-node:10
WORKDIR /usr/src
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY . .
RUN yarn build && yarn cache clean;
RUN mv ./build /public
