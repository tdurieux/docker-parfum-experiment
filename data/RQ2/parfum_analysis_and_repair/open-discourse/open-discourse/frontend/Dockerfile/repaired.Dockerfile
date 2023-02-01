FROM node:12

COPY . /srv

WORKDIR /srv/

RUN yarn && yarn cache clean;

EXPOSE 3000

CMD ["yarn", "dev"]
