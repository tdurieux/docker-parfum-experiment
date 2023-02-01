FROM appliedblockchain/b-explorer

RUN mkdir /home/explorer/app/bin
RUN cd bin && npm i node-fetch && npm cache clean --force;

COPY config.js /home/explorer/app

CMD node server.js
