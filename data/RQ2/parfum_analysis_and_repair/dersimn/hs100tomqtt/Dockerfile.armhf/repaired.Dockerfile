FROM arm32v7/node:slim

COPY . /node

RUN cd /node && \
	npm install && npm cache clean --force;

ENTRYPOINT [ "node", "/node/index.js" ]
