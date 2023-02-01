FROM node:10-alpine

ADD package.json package-lock.json ./
RUN npm install && npm cache clean --force;
ADD . .
RUN npm run-script build

CMD ["node", "dist/main"]

EXPOSE 8080
