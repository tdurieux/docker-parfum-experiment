FROM node:16
COPY . .
RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;
CMD [ "yarn", "start:prod" ]