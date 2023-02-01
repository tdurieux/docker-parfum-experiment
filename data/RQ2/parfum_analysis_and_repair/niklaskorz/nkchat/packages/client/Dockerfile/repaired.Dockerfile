FROM node:12

COPY . /client
WORKDIR /client
RUN yarn --frozen-lockfile && yarn cache clean;
RUN yarn build && yarn cache clean;

EXPOSE 3000

CMD ["yarn", "serve", "--port", "3000", "--clipless"]
