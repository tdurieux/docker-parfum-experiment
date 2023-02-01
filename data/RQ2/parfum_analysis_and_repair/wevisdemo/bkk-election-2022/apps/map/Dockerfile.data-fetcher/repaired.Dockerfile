FROM node:16-alpine

WORKDIR /app
COPY package.json ./
RUN npm i && npm cache clean --force;

COPY . .

ENV ERS_API_KEY=
CMD npm run fetch-data