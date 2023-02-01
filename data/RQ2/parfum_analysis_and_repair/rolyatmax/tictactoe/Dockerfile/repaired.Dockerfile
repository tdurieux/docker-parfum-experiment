FROM node:14-slim

WORKDIR /app
COPY . .
RUN npm install && npm cache clean --force;

WORKDIR /app/public
RUN npm install && npm cache clean --force;
RUN npm run build

WORKDIR /app
CMD [ "npm", "start" ]
