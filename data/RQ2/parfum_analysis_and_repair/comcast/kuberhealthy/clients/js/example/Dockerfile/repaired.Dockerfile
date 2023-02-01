FROM node
COPY . .
RUN npm install && npm cache clean --force;

ENTRYPOINT ["node", "check.js"]