FROM node:14-bullseye
COPY . /
RUN yarn && yarn cache clean;
EXPOSE 5000
CMD ["yarn", "server"]