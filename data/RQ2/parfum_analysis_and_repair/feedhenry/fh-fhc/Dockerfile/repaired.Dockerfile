FROM nodesource/centos7:4.4.7

ADD package.json package.json
RUN npm install && npm cache clean --force;
ADD . .

ENTRYPOINT ["node", "bin/fhc.js"]
