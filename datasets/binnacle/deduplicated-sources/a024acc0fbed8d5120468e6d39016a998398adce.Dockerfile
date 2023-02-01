FROM ethereum/client-go:stable

RUN apk add --update git bash nodejs nodejs-npm perl

RUN npm i -g npm@latest

RUN cd /root &&\
    git clone https://github.com/EthereumEx/eth-net-intelligence-api &&\
    cd eth-net-intelligence-api &&\
    npm install &&\
    npm audit fix &&\
    npm doctor &&\
    npm install -g pm2

ADD start.sh /root/start.sh
ADD app.json /root/eth-net-intelligence-api/app.json
RUN chmod +x /root/start.sh

ENTRYPOINT /root/start.sh
