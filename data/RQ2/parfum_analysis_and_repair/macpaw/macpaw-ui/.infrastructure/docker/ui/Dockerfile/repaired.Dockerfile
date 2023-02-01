FROM node:16

ARG NPM_TOKEN

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm config set //npm.pkg.github.com/:_authToken=${NPM_TOKEN}
RUN npm config set @macpaw:registry=https://npm.pkg.github.com
RUN npm install && npm cache clean --force;

COPY . .
RUN npm run build

ENTRYPOINT [ "npm", "run" ]
