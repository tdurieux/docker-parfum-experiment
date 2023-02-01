# gcr.io/eqx-host/backend:<hash>

FROM strapi/base:14

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .

RUN npm run-script build

CMD [ "npm", "run", "dev" ]
