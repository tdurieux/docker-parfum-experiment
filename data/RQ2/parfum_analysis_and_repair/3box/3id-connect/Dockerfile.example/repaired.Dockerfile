FROM node:10

WORKDIR /3id-connect

COPY package.json package-lock.json ./

COPY src ./src
COPY webpack*.config.js .babelrc ./
COPY public ./public

EXPOSE 30001

CMD npm run start