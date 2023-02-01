FROM node:12-buster-slim

WORKDIR /app
COPY package.json .

ENV NODE_ENV production
ENV PORT 9999
RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 9999

CMD ["node", "/app/server.js"]
