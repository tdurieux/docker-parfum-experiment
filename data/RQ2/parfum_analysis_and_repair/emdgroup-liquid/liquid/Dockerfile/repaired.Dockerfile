FROM node:17-alpine
WORKDIR /app
COPY . .
RUN yarn && yarn cache clean;
CMD ["yarn", "start"]
