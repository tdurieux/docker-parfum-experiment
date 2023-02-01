FROM node:latest

RUN mkdir Mr-Grape
WORKDIR Mr-Grape

COPY package*.json .
RUN npm i --save && npm cache clean --force;

COPY . .

CMD ["npm", "start"]
