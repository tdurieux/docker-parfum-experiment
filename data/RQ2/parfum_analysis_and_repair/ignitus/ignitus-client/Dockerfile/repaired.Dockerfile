# base image
FROM node:8

# set working directory
RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json /usr/src/app/package.json
RUN npm install --silent && npm cache clean --force;
RUN npm install react-scripts@1.1.1 -g --silent && npm cache clean --force;

# start app
CMD ["npm", "start"]