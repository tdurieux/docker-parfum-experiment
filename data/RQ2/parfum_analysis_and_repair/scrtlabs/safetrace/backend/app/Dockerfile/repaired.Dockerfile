#define the latest nodejs image  to build from
FROM node:latest
RUN mkdir -p /usr/src/apiServerUsers && rm -rf /usr/src/apiServerUsers

#create a working directory
WORKDIR /usr/src/apiServerUsers
RUN npm install -g nodemon --save && npm cache clean --force;

#copy package.json file under the working directory
COPY package.json /usr/src/apiServerUsers/
RUN npm install && npm cache clean --force;

#copy all your files under the working directory
COPY . /usr/src/apiServerUsers/

EXPOSE 4080
#start nodejs server
CMD nodemon server.js