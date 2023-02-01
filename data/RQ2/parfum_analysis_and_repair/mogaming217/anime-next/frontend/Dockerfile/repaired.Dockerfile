FROM node:12-alpine
WORKDIR /usr/src/app
COPY . .
RUN npm install --production && npm cache clean --force;

ENV HOST 0.0.0.0

CMD ["npm", "run", "start"]
