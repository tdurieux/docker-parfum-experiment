FROM node:12-alpine
WORKDIR /usr/src/app
RUN apk update && apk add --no-cache --virtual bash coreutils
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build
COPY docker/entrypoint.sh entrypoint.sh
EXPOSE 3000
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
