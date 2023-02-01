FROM node:10-alpine
RUN apk add --no-cache nmap

WORKDIR /app
COPY package.json .
RUN npm install && npm cache clean --force;
ADD . /app
EXPOSE 3000
CMD ["node", "index.js"]

