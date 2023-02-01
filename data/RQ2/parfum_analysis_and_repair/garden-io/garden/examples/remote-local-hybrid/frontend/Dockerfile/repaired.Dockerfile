FROM node:12.22.6-alpine

ENV PORT=8080
EXPOSE ${PORT}
WORKDIR /app

COPY package.json /app
RUN npm install && npm cache clean --force;

COPY . /app

CMD ["npm", "start"]
