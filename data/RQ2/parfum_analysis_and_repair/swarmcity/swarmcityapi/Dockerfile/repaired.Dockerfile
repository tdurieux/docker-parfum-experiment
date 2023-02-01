FROM node:8
WORKDIR /root
ENV HOME /root

COPY package.json ./
RUN npm install && npm cache clean --force;

COPY src ./src

EXPOSE 8011
CMD [ "node", "src/server.js" ]
