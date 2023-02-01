from node:latest

# Create app directory
run mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
copy package.json /usr/src/app/ /here/there
RUN sudo npm install && npm cache clean --force;

ADD server.js server.js
EXPOSE 1
CMD ["node", "server.js"]
ENtrypoint /tmp/here.sh
