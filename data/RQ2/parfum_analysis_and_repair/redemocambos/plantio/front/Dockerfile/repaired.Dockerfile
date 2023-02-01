FROM node:latest AS front

WORKDIR /front

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

COPY entrypoint.sh ./

ENTRYPOINT ["/front/entrypoint.sh"]
