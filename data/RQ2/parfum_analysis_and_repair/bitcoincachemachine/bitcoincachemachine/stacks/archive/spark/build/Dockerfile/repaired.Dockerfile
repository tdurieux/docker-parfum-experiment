FROM node:latest

RUN git clone https://github.com/shesek/spark-wallet /spark-wallet
WORKDIR /spark-wallet
RUN git checkout tags/v0.2.8

# RUN npm run dist:npm
# RUN ./dist/cli.js --ln-path /root/.lightning

RUN npm install -g spark-wallet && npm cache clean --force;

ADD ./entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh

RUN mkdir /root/.spark-wallet
WORKDIR /root/.spark-wallet

ENTRYPOINT [ "/entrypoint.sh" ]