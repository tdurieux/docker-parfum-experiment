# not slim because we need github depedencies
FROM root-builder as builder

# Create app directory
WORKDIR /app

COPY package.json .
COPY packages/client/package.json ./packages/client/
COPY packages/client-core/package.json ./packages/client-core/
COPY packages/editor/package.json ./packages/editor/
COPY packages/hyperflux/package.json ./packages/hyperflux/

ARG NODE_ENV
RUN npm install --loglevel notice --legacy-peer-deps && npm cache clean --force;

# copy then compile the code
COPY . .

ARG MYSQL_HOST
ARG MYSQL_USER
ARG MYSQL_PORT
ARG MYSQL_PASSWORD
ARG MYSQL_DATABASE
ARG VITE_CLIENT_HOST
ARG VITE_CLIENT_PORT
ARG VITE_SERVER_HOST
ARG VITE_SERVER_PORT
ARG VITE_MEDIATOR_SERVER
ARG VITE_INSTANCESERVER_HOST
ARG VITE_INSTANCESERVER_PORT
ARG VITE_LOCAL_BUILD
ENV MYSQL_HOST=$MYSQL_HOST
ENV MYSQL_PORT=$MYSQL_PORT
ENV MYSQL_PASSWORD=$MYSQL_PASSWORD
ENV MYSQL_DATABASE=$MYSQL_DATABASE
ENV MYSQL_USER=$MYSQL_USER
ENV VITE_CLIENT_HOST=$VITE_CLIENT_HOST
ENV VITE_CLIENT_PORT=$VITE_CLIENT_PORT
ENV VITE_SERVER_HOST=$VITE_SERVER_HOST
ENV VITE_SERVER_PORT=$VITE_SERVER_PORT
ENV VITE_MEDIATOR_SERVER=$VITE_MEDIATOR_SERVER
ENV VITE_INSTANCESERVER_HOST=$VITE_INSTANCESERVER_HOST
ENV VITE_INSTANCESERVER_PORT=$VITE_INSTANCESERVER_PORT
ENV VITE_LOCAL_BUILD=$VITE_LOCAL_BUILD

RUN npm run build-client

ENV APP_ENV=production

FROM node:16-buster-slim as runner
WORKDIR /app

COPY --from=builder /app/packages/client ./packages/client
COPY --from=builder /app/scripts ./scripts

RUN npm install express app-root-path && npm cache clean --force;

CMD ["scripts/start-server.sh"]
