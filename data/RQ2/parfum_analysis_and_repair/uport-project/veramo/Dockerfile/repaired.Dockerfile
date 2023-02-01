FROM node:18
WORKDIR /usr/src/app
COPY . .
RUN yarn && yarn cache clean;
RUN yarn bootstrap && yarn cache clean;
RUN yarn build && yarn cache clean;
ENTRYPOINT ["./packages/cli/bin/veramo.js"]