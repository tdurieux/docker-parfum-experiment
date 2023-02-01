FROM node:14

EXPOSE 9600

# copy
WORKDIR /app
COPY ["package.json", "npm-shrinkwrap.json", "routes.js", "index.js", "config.json", "child.js", "./"]
COPY ["./app", "./app"]
COPY ["./bin", "./bin"]
COPY ["./editor", "./editor"]

# install
RUN npm install --production && npm cache clean --force;

# run
CMD [ "node", "./bin/xible.js", "server", "start" ]
