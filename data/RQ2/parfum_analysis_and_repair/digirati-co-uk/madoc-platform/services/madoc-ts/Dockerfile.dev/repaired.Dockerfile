FROM node:14

WORKDIR /home/node/app

RUN npm install -g pm2@4.5.6 ts-node && npm cache clean --force;

COPY ./package.json /home/node/app/package.json
COPY ./yarn.lock /home/node/app/yarn.lock
COPY ./npm /home/node/app/npm

RUN yarn install --no-dev --no-interactive --frozen-lockfile && yarn cache clean;

COPY ./schemas /home/node/app/schemas
COPY ./src /home/node/app/src
COPY ./ecosystem.config.js /home/node/app/ecosystem.config.js
COPY ./migrate.js /home/node/app/migrate.js
COPY ./tsconfig.json /home/node/app/tsconfig.json
COPY ./tsconfig.frontend.json /home/node/app/tsconfig.frontend.json
COPY ./migrations /home/node/app/migrations
COPY ./config.json /home/node/app/config.json
COPY ./webpack.config.js /home/node/app/webpack.config.js
COPY ./generate-schemas.js /home/node/app/generate-schemas.js
COPY ./translations /home/node/app/translations
COPY ./schemas /home/node/app/schemas
COPY ./themes /home/node/app/themes

ENV SERVER_PORT=3000
ENV DATABASE_HOST=localhost
ENV DATABASE_NAME=postgres
ENV DATABASE_PORT=5400
ENV DATABASE_USER=postgres
ENV DATABASE_SCHEMA=public
ENV DATABASE_PASSWORD=postgres
ENV NODE_ENV=development
ENV API_GATEWAY_HOST=http://gateway

RUN yarn build

EXPOSE 3000
EXPOSE 3001
EXPOSE 9230

CMD ["yarn", "dev"]

