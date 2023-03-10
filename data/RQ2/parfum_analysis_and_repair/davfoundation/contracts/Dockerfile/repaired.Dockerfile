FROM node:9
RUN npm install -g ganache-cli truffle && npm cache clean --force;
VOLUME [ "/contracts" ]
WORKDIR /contracts
CMD [ "bash","-c","./migrate.sh" ]
EXPOSE 8545
