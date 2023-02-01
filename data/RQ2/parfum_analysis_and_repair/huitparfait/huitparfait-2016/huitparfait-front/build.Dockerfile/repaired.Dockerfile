FROM node:6.2

RUN mkdir /app
WORKDIR /app

COPY ./package.json /app

RUN npm install && npm cache clean --force;

COPY . /app

VOLUME /app/dist

ENTRYPOINT ["npm", "run", "build"]
