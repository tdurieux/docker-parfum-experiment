FROM node:10
RUN mkdir -p webpack-clean
WORKDIR /webpack-clean
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY . ./
EXPOSE 8080
CMD yarn test