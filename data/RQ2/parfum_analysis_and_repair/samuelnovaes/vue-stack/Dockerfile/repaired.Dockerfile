FROM alpine
RUN apk add --no-cache --update nodejs npm
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --production && npm cache clean --force;
COPY . .
RUN npm run build
EXPOSE 3000
CMD [ "npm", "start" ]