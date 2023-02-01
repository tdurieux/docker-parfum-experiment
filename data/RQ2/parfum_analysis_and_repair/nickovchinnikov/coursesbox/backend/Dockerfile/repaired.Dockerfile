FROM node:16
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt

COPY ./package.json ./
COPY ./package-lock.json ./

ENV PATH /opt/node_modules/.bin:$PATH

RUN npm install && npm cache clean --force;

WORKDIR /opt/app

COPY /. .

RUN npm run build

EXPOSE 1337

CMD ["npm", "start"]
