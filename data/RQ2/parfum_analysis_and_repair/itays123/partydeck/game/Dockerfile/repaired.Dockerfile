FROM node:12

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

ARG REACT_APP_SERVER_URL

ENV REACT_APP_SERVER_URL $REACT_APP_SERVER_URL

ARG REACT_APP_SERVER_WS

ENV REACT_APP_SERVER_WS $REACT_APP_SERVER_WS

RUN npm run build

RUN npm install -g serve && npm cache clean --force;

EXPOSE $PORT

CMD serve -s build -l $PORT