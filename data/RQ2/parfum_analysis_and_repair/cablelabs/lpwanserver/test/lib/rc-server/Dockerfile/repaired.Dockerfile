FROM node:10.15-alpine

# set working directory
WORKDIR /usr/src/app

# Copy project files
COPY test/lib/rc-server/* ./

RUN npm install --production && npm cache clean --force;

EXPOSE 8080

CMD [ "node", "index.js" ]
