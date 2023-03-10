FROM node:10.21.0-jessie

WORKDIR /app

COPY package.json /app

RUN npm install && npm cache clean --force;
#&& npm install -g nodemon

COPY . .

EXPOSE 3333

#ENTRYPOINT [ "nodemon","--max-old-space-size=4096","server.js" ]
ENTRYPOINT ["npm" ,"start","-s"]