FROM node

RUN git clone https://github.com/goerli/netstats-server /netstats-server
WORKDIR /netstats-server
RUN npm install && npm cache clean --force;
RUN npm install -g grunt-cli && npm cache clean --force;
RUN grunt

EXPOSE  3000
CMD ["npm", "start"]
