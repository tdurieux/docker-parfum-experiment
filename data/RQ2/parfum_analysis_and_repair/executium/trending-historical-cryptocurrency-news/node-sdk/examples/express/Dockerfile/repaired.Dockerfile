FROM node:lts

ENV NODE_ENV=production

COPY . /app

WORKDIR /app

RUN yarn install && yarn cache clean;

EXPOSE 3000

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["yarn start"]
