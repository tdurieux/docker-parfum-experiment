FROM node:16
WORKDIR /app
COPY . .
RUN yarn install --production && yarn cache clean;
RUN yarn build
CMD ["yarn", "serve"]
EXPOSE 8080
