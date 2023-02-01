FROM node

COPY package.json /app/package.json
WORKDIR /app

# Install app dependencies
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . /app

COPY ./docker/run /usr/bin/k8s-watcher
CMD ["/usr/bin/k8s-watcher"]
