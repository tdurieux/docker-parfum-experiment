FROM node:14-alpine

WORKDIR /usr/app

ENV PATH /usr/app/node_modules/.bin:$PATH

COPY package.json /usr/app/package.json
RUN npm install && npm cache clean --force;

COPY . .

CMD ["npm", "run", "start"]