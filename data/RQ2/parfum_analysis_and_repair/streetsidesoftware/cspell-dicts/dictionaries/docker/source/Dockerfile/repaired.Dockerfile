FROM node:12-alpine
RUN apk add --no-cache python2 g++ make
WORKDIR /app
COPY . .
RUN yarn install --production && yarn cache clean;
CMD ["node", "src/index.js"]
EXPOSE 3000
