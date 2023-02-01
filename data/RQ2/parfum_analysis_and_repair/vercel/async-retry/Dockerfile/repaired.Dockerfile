FROM mhart/alpine-node:10.7.0
WORKDIR /usr/src
COPY package.json .
COPY yarn.lock .
RUN yarn && yarn cache clean --force && yarn cache clean;
COPY . .

# Run tests
RUN yarn test && yarn cache clean;
RUN mkdir /public && echo "<marquee direction="right">All tests passed!</marquee>" > /public/index.html
