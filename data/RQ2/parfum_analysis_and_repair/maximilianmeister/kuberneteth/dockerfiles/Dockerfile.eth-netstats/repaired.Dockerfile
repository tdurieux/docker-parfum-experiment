FROM node:6

RUN git clone https://github.com/cubedro/eth-netstats
RUN cd /eth-netstats && npm install && npm cache clean --force;
RUN cd /eth-netstats && npm install -g grunt-cli && npm cache clean --force;
RUN cd /eth-netstats && grunt

ENV PORT 3001

EXPOSE 3001

CMD cd /eth-netstats && npm start
