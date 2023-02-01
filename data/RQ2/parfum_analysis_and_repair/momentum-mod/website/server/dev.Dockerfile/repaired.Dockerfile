FROM node:12

WORKDIR /app/server

COPY . .

RUN yarn install --frozen-lockfile && yarn cache clean;
RUN yarn global add nodemon ts-node

ENTRYPOINT ["npm", "run", "dev"]
