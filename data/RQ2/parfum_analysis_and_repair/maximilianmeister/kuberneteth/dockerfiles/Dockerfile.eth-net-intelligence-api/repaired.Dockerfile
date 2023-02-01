FROM node:6

RUN git clone https://github.com/cubedro/eth-net-intelligence-api
RUN cd /eth-net-intelligence-api && npm install && npm cache clean --force;
RUN cd /eth-net-intelligence-api && npm install -g pm2 && npm cache clean --force;

CMD cd /eth-net-intelligence-api && pm2 --no-daemon start app.json
