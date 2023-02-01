#FROM resin/qemux86-64-node:slim
FROM node:6-slim
RUN apt-get update && apt-get install --no-install-recommends -y git ssh && rm -rf /var/lib/apt/lists/*;
RUN npm install git+https://git@github.com/kpavel/openwhisk-light.git pouchdb && npm cache clean --force && rm -rf /tmp/*
CMD ["sh", "-c", "cd /node_modules/openwhisk-light; npm start"]
