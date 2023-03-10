FROM node:18.4.0
ENV NODE_ENV=production

WORKDIR /app

COPY ["package.json", "package-lock.json*", "./"]

RUN npm install --production && npm cache clean --force;

COPY generated /app/generated
COPY proto /app/proto
COPY aggregate.js .
COPY streaming-aggregator.js .

CMD [ "node", "aggregate.js" ]