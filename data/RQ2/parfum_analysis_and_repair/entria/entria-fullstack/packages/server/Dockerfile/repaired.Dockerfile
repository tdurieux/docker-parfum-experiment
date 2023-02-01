FROM node:lts

LABEL maintainer="Entria <hello@entria.com.br>"

RUN mkdir -p /app
WORKDIR /app

COPY package.json /app
RUN npm i && npm cache clean --force;

COPY . /app

#cachable
RUN npm run build

CMD ["npm", "start"]
