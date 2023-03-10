FROM node:latest

# set working directory
RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# install and cache app dependencies
COPY package.json package-lock.json /usr/src/app/
RUN cd /usr/src/app && npm install --silent && npm cache clean --force;

# add app
COPY . /usr/src/app

# start app
CMD ["npm", "start"]
