FROM mhart/alpine-node:9.7

RUN npm install -g ganache-cli@6.0.3 && npm cache clean --force;

ADD ganache.sh ganache.sh

RUN chmod +x ganache.sh

EXPOSE 8545

CMD sh ganache.sh