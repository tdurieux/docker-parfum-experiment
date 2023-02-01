FROM node:12.22.6-alpine

ENV PORT=8080
EXPOSE ${PORT}

RUN npm install -g nodemon && npm cache clean --force;

ADD . /app
WORKDIR /app

RUN npm install && npm cache clean --force;

CMD ["npm", "start"]
