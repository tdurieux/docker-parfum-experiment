FROM node:15-alpine

COPY ./package*.json ./
RUN npm ci

COPY ./src ./src

EXPOSE 8080

CMD [ "npm", "run", "mockServer" ]