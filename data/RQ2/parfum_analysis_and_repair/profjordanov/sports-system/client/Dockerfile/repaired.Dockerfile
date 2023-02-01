FROM node:12.2.0-alpine

WORKDIR /app

COPY . .

ENV PATH /app/node_modules/.bin:$PATH

COPY package.json /app/package.json
RUN npm install && npm cache clean --force;
RUN npm install react-scripts@3.0.1 -g && npm cache clean --force;

ARG REACT_APP_ENVIRONMENT

RUN npm run build:${REACT_APP_ENVIRONMENT}

RUN npm install -g serve && npm cache clean --force;

CMD ["serve", "-s", "build", "-l", "3000"]