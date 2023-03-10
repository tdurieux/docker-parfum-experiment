# NOTE: Use either docker.io or your own registry address to build the image
ARG SOURCE_CONTAINER_REGISTRY_ADDRESS=your-registry-address.azurecr.io
FROM $SOURCE_CONTAINER_REGISTRY_ADDRESS/amd64/node:14-alpine

WORKDIR /app/

COPY package*.json ./
COPY NOTICE.txt ./

RUN npm install --production && npm cache clean --force;

COPY *.js ./
COPY codecs ./codecs

USER node

EXPOSE 8080

CMD ["node", "app.js"]
