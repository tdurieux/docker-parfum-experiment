FROM node:14

WORKDIR /app
COPY . .

RUN npm install && npm cache clean --force;

EXPOSE 3000

ENTRYPOINT ["node", "/app/index.mjs"]
