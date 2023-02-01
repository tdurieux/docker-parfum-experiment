FROM alpine
RUN apk add --no-cache --update nodejs npm --repository=http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/

ENV NODE_ENV production

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --production && npm cache clean --force;
COPY . .

EXPOSE 8080 8081

ENTRYPOINT ["node", "app.js"]