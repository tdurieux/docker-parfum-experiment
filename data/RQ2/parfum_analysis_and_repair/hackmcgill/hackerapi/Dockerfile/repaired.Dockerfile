FROM node:carbon

ENV PORT 8080

WORKDIR /usr/src/app

COPY package*.json ./
ADD VERSION .

RUN npm install -g n && npm cache clean --force;
RUN n 9.9.0
RUN npm install npm -g && npm cache clean --force;
RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 8080
CMD [ "npm", "run", "debug" ]