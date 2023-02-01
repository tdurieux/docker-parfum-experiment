FROM node:17

WORKDIR /src

COPY . .

RUN NODE_ENV='production'
RUN export NODE_ENV

RUN npm i && npm cache clean --force;

CMD npm run start:prod