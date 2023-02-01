FROM node:8.11.4

WORKDIR /app/website

EXPOSE 4000 35729
COPY ./docs /app/docs
COPY ./website /app/website
RUN yarn install && yarn cache clean;

CMD ["yarn", "start"]
