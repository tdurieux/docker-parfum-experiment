FROM node:10.16.1-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY ./data/countryCurrencyMetadata.csv swagger.yaml ./

COPY src ./src

EXPOSE 4001

CMD ["npm", "start"]

