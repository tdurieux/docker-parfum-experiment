FROM	node:alpine

WORKDIR /src

RUN npm i express body-parser && npm cache clean --force;
COPY	cryptor-mock.js /src

EXPOSE	26272
CMD	node /src/cryptor-mock.js
