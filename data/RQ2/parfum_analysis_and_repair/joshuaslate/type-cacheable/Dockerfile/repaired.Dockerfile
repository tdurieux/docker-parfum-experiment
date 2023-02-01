FROM node:lts
WORKDIR /app
COPY . /app
RUN yarn && yarn cache clean;

CMD ["yarn", "test"]
