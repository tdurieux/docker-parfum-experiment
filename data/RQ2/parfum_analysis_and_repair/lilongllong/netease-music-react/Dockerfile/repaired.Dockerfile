FROM node:boron

MAINTAINER Longlong Li <2453085960@qq.com>

# creat workdir
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install dependencies
COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;

# copy other codes and resources
COPY . /usr/src/app

EXPOSE 8080
# ENTRYPOINT diff CMD CDM can be overrided
CMD [ "npm", "start" ]
