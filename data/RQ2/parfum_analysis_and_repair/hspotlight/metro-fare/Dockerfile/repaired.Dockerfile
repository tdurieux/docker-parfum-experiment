FROM node:lts-bullseye

ENV HOME=/home/node

COPY . $HOME
WORKDIR $HOME
RUN yarn install && yarn build && yarn cache clean;

EXPOSE 3000
CMD ["yarn", "start"]