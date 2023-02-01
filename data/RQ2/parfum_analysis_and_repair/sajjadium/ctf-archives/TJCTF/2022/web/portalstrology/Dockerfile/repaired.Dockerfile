FROM node:14-buster-slim

WORKDIR /app
COPY . .

RUN npm i && npm cache clean --force;

EXPOSE 3000

ENV ENV=development

CMD ["node", "index.js"]
