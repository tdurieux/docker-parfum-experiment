FROM node:alpine
ARG api

WORKDIR ${api}
COPY ${api}package.json .
RUN npm install && npm cache clean --force;
COPY ${api} .

ENTRYPOINT ["npm", "run", "start"]