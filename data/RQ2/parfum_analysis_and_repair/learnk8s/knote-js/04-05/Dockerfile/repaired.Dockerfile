FROM node:12.0-slim
COPY . .
RUN npm install && npm cache clean --force;
CMD [ "node", "index.js" ]
