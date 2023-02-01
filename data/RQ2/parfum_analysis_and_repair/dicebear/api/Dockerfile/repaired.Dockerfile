FROM node:16-slim

EXPOSE 3000

WORKDIR /dicebear-api

COPY . .
RUN npm install && npm cache clean --force;

CMD ["npm", "start"]