FROM    node:0.10.28
ADD package.json /tmp/package.json
RUN cd /tmp && npm install && npm cache clean --force;
RUN mkdir -p /app && cp -a /tmp/node_modules /app/
WORKDIR /app
ADD . /app