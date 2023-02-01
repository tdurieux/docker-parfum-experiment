FROM node:14.4.0-slim

WORKDIR /app
ADD . /app/

RUN npm install --silent && npm cache clean --force;

CMD ["npm", "start"]