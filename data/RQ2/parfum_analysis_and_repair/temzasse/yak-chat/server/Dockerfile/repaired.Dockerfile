FROM node:8.6-alpine

RUN apk add --no-cache --update-cache build-base python git

WORKDIR /app

ENV NODE_ENV development

COPY ./package.json /app/package.json
RUN npm install nodemon -g && npm cache clean --force;
RUN npm install --quiet && npm cache clean --force;

COPY . /app

EXPOSE 3332

CMD ["npm", "run", "start"]