FROM node:16.9.1

WORKDIR /app

COPY ./package.json ./package.json
RUN npm install --force && npm cache clean --force;

COPY . .

CMD npm run start
