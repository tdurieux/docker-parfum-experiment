FROM ubuntu:bionic

RUN apt-get update && apt-get install --no-install-recommends -y gnupg curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Upgrade npm
RUN npm i npm@latest -g && npm cache clean --force;

# Create a sample app
RUN echo "var express = require('express');var app = express();app.get('/', function (req, res) {res.send('Hello World!');});app.listen(8080, function () {});" >> index.js
RUN echo "{\"name\": \"mtlstest\",\"version\": \"1.0.0\",\"main\": \"index.js\",\"scripts\": {\"start\": \"node index.js\"},\"dependencies\": {\"express\": \"^4.16.1\"}}" >> package.json
RUN npm install --save express && npm cache clean --force;
EXPOSE 8080
CMD [ "npm", "start" ]