FROM node:14.18-alpine

WORKDIR /app

COPY dist/apps/api ./

EXPOSE 3333
RUN npm i --production && npm cache clean --force;
CMD ["node", "main.js"]
