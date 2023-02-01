FROM node:lts

WORKDIR /app/website

EXPOSE 3000 35729
COPY ./documentation/src /app/src
COPY ./documentation/website /app/website
RUN yarn install && yarn cache clean;

CMD ["yarn", "start"]
