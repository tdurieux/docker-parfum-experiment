FROM node:10

WORKDIR /usr/ui

COPY package.json .
RUN npm install --quiet && npm cache clean --force;

COPY . .

RUN npm run build

CMD npm start