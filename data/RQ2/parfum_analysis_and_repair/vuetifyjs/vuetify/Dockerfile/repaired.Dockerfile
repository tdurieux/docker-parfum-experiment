FROM mhart/alpine-node:12

COPY . .

EXPOSE 8095

RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;
CMD ["yarn", "start"]
