FROM node:11

WORKDIR /app
ADD . .
RUN npm install && npm run build && npm cache clean --force;

ENTRYPOINT [ "npm", "run", "start" ]
