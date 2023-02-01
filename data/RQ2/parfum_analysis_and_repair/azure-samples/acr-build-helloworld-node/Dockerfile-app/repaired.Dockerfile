ARG REGISTRY_NAME
FROM ${REGISTRY_NAME}/baseimages/node:15-alpine

COPY . /src
RUN cd /src && npm install && npm cache clean --force;
EXPOSE 80
CMD ["node", "/src/server.js"]
