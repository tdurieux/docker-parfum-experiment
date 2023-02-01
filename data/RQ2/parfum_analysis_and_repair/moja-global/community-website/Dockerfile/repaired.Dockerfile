FROM node:lts

WORKDIR /app/website

EXPOSE 3000 35729
COPY ./website /app/website
RUN yarn install && yarn cache clean;
RUN yarn build

CMD ["yarn", "serve"]
