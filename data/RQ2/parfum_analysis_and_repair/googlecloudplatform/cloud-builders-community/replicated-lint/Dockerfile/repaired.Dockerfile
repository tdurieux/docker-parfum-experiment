FROM node:alpine

RUN npm install -g replicated-lint && npm cache clean --force;

ENTRYPOINT ["replicated-lint"]
