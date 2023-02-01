FROM node:lts-fermium
WORKDIR /var/base
RUN npm i -g browserify && npm cache clean --force;
ENTRYPOINT browserify src/index.js -o dist/index.js -s jspreadsheet