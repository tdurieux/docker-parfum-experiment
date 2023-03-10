FROM arm32v7/node:14

WORKDIR /usr/src/app

COPY ./src/aux-server/package*.json ./

RUN npm install --only=production && npm cache clean --force;

COPY ./src/aux-server/server/dist ./server/dist/
COPY ./src/aux-server/aux-web/dist ./aux-web/dist/

ENV PRODUCTION 1

# Specify no sandbox since Deno doesn't support Arm32
ENV SANDBOX_TYPE "none"

# Specify GPIO is enabled by default
ENV GPIO "true"

# HTTP
EXPOSE 3000

# WebSocket
EXPOSE 4567

CMD [ "npm", "start" ]
