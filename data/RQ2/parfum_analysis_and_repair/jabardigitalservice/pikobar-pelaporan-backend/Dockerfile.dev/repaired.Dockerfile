FROM node:10.21.0-jessie

WORKDIR /app

COPY package.json /app

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3333

ENTRYPOINT ["npm" ,"start","-s"]