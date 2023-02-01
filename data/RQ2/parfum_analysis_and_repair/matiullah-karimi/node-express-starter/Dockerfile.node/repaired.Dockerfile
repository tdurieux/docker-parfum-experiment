FROM node:14.15.0-alpine

# RUN apk add libvips

WORKDIR /usr/src/app

COPY package.json .

RUN npm install --force && npm cache clean --force;

EXPOSE 3000

CMD ["npm", "start"];
