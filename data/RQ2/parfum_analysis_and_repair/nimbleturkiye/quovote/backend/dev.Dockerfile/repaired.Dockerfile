FROM node:alpine

WORKDIR /app
RUN npm install -g nodemon && npm cache clean --force;

ADD package.json package-lock.json ./
RUN npm install && npm cache clean --force;

ENV NODE_ENV=development

ADD bin ./bin

VOLUME [ "/app/src" ]

CMD ["nodemon"]
