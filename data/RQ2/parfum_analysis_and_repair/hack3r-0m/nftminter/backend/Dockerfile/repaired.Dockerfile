FROM node:14

# create & set working directory
WORKDIR /app

# copy source files
COPY . /app

# install dependencies
RUN npm install && npm cache clean --force;

RUN npm install pm2 -g && npm cache clean --force;

# start app
EXPOSE 8080

CMD ["pm2-runtime", "start", "server.js", "-i", "max"]
