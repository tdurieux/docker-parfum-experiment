FROM node:12-alpine

WORKDIR /app
COPY . /app

RUN npm install --silent && npm cache clean --force;

EXPOSE 3000

CMD ["npm","start"]