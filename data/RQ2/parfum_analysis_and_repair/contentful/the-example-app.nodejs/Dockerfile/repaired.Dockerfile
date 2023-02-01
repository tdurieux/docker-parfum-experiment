FROM node:9

WORKDIR /app

RUN npm install -g contentful-cli && npm cache clean --force;

COPY package.json .
RUN npm install && npm cache clean --force;

COPY . .

USER node
EXPOSE 3000

CMD ["npm", "run", "start:dev"]
