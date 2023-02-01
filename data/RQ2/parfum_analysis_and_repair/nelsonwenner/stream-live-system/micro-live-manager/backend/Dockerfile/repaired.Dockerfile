FROM node:10.16-slim

RUN mkdir -p /backend/src

WORKDIR /backend/src

COPY . .

RUN npm install && npm cache clean --force;

RUN npm run build

CMD ["npm", "run", "start:prod"]