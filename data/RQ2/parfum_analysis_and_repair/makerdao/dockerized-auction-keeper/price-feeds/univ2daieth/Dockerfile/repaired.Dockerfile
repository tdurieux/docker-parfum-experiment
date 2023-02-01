FROM node:12

WORKDIR /opt/price-feed
COPY . .
RUN npm install && npm cache clean --force;

EXPOSE 3000
CMD [ "node", "index.js" ]
