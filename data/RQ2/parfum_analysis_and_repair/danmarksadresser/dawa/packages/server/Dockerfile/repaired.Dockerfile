FROM node:lts
WORKDIR /app
COPY . .
RUN yarn install && yarn cache clean;
EXPOSE 3000
EXPOSE 3001
CMD ["node_modules/.bin/dawa-server"]