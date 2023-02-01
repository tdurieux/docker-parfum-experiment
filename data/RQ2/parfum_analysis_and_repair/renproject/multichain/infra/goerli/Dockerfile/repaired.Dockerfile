FROM node:alpine

WORKDIR /root/app

COPY package.json .
RUN npm install && npm cache clean --force;

COPY hardhat.config.js .
COPY run.sh .
RUN chmod +x run.sh

EXPOSE 8545

ENTRYPOINT ["./run.sh"]
