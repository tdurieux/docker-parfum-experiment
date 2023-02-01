FROM node:8-slim

WORKDIR .

COPY . .

RUN npm install && npm cache clean --force;

EXPOSE 3000

CMD ["npm", "start"]
