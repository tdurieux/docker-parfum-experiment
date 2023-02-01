FROM node:16-buster

RUN mkdir -p /app

WORKDIR /app

COPY package.json package-lock.json DeploymentMarker.js ./

RUN npm install && npm cache clean --force;

CMD [ "node" "/app/DeploymentMarker.js" ]
