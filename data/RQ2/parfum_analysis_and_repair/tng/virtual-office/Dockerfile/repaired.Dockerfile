FROM node:16 as build
ENV CYPRESS_INSTALL_BINARY=0

WORKDIR /app

COPY ./package*.json ./
COPY client/package*.json ./client/
COPY server/package*.json ./server/
RUN npm install && npm cache clean --force;

COPY client ./client/
COPY server ./server/

RUN npm run build --workspaces

FROM node:16
ENV NODE_ENV=production

WORKDIR /app

COPY ./package*.json ./
COPY server/package*.json ./server/
RUN npm install && npm cache clean --force;

USER node

COPY --chown=node --from=build /app/client/build ./client/build
COPY --chown=node --from=build /app/server/build ./server/build

EXPOSE 9000

CMD [ "node", "server/build/server/index.js" ]
