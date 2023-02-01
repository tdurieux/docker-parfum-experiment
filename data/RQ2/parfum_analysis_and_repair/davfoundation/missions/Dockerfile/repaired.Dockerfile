FROM node:9
RUN npm i -g webpack webpack-cli && npm cache clean --force;

WORKDIR /app
COPY . /app
RUN npm i && npm cache clean --force;

CMD npm run start-stg

EXPOSE 3333