# WIP

FROM node:14

WORKDIR /app

ADD . /app

RUN npm install && npm cache clean --force;
RUN npx lerna bootstrap

EXPOSE 3000

CMD ["npm", "run", "dev"]