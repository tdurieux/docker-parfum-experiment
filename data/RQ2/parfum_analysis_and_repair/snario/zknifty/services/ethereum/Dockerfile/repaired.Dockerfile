FROM trufflesuite/ganache-cli:v6.1.8

RUN npm i -g truffle@beta && npm cache clean --force;

COPY . /ethereum