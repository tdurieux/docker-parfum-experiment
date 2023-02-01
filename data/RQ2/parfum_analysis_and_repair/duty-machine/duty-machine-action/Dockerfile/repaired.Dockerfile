FROM node:alpine

#RUN apk --no-cache add curl

WORKDIR /usr/app

COPY . .

RUN npm install && npm cache clean --force;

ENTRYPOINT ["node", "--unhandled-rejections=strict", "/usr/app/perform.js"]
