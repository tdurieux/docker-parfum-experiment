FROM iojs

RUN git clone https://github.com/cubedro/eth-netstats
RUN cd /eth-netstats && npm install && npm cache clean --force;
RUN cd /eth-netstats && npm install -g grunt-cli && npm cache clean --force;
RUN cd /eth-netstats && grunt

WORKDIR /eth-netstats

CMD ["npm", "start"]
