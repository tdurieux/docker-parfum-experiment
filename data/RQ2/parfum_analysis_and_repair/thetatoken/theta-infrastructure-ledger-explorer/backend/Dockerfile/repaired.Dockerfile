FROM node:12.19.0
ENV NODE_ENV=production
ENV MONGO_HOST "host.docker.internal"

COPY . .

COPY ["./explorer-api/package.json", "./explorer-api/package-lock.json*", "./"]

WORKDIR /explorer-api

RUN npm install --production && npm cache clean --force;

CMD [ "node", "run.js" ]