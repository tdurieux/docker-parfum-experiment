FROM node:latest

WORKDIR /app
COPY . /app

RUN npm install && \
    scripts/sync-storage && \
    npm run build && npm cache clean --force;

EXPOSE 4002

CMD ["npm", "start"]
