FROM node:boron
COPY server.js package.json /app/
RUN npm install /app/ && npm cache clean --force;
CMD ["node", "/app/server.js"]