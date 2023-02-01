FROM node:14.11.0-alpine3.10

WORKDIR /usr/src/app

COPY ./dist ./
COPY ./package.json ./
COPY ./package-lock.json ./
COPY ./tsconfig.json ./

RUN npm install --production && npm cache clean --force;

# node -r tsconfig-paths/register .\src\shared\api\http\server.js
CMD ["node", "-r", "tsconfig-paths/register", "./src/shared/api/http/server.js"]
