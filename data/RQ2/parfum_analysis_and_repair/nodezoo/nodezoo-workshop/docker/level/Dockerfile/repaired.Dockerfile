FROM node:4
ADD . /
RUN npm install && npm cache clean --force;


# build and create:
# $ docker-machine restart default
# $ docker build -t nodezoo-level .
# $ docker create -v /node_modules/seneca-level-store --name nodezoo-level nodezoo-level /bin/true


