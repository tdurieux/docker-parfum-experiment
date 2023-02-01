FROM node:alpine

RUN npm install -g postgraphile && npm cache clean --force;
RUN npm install -g postgraphile-plugin-connection-filter && npm cache clean --force;
RUN npm install -g @graphile/pg-pubsub && npm cache clean --force;

EXPOSE 5000
ENTRYPOINT ["postgraphile"]