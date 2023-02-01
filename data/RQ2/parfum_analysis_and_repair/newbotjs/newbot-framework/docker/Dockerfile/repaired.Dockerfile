FROM node:12

RUN npm i -g newbot-cli && npm cache clean --force;

EXPOSE 3000

CMD newbot serve