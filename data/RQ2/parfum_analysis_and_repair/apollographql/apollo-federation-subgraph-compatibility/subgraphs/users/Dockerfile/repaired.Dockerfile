FROM node:14-alpine
WORKDIR /web
COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;
COPY index.js users.graphql ./
EXPOSE 4002
USER node
CMD node index.js
