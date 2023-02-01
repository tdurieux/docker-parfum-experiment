FROM node:6

RUN git clone https://github.com/cubedro/eth-netstats
RUN cd /eth-netstats && npm install && npm cache clean --force;
RUN cd /eth-netstats && npm install -g grunt-cli && npm cache clean --force;
RUN cd /eth-netstats && grunt

RUN git clone https://github.com/cubedro/eth-net-intelligence-api
RUN cd /eth-net-intelligence-api && npm install && npm cache clean --force;
RUN cd /eth-net-intelligence-api && npm install -g pm2 && npm cache clean --force;

ENV PORT 3001

EXPOSE 3001

CMD cd /eth-net-intelligence-api && pm2 start app.json; cd /eth-netstats && npm start
