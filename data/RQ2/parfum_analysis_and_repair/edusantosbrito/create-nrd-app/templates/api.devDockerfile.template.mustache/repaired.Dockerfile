FROM node:14-slim
WORKDIR /usr/src/app
COPY . .
RUN yarn && yarn cache clean;
EXPOSE 3001
CMD [ "yarn", "run", "dev" ]