# base image
FROM node:9.6.1

# set working directory
RUN mkdir /usr/src/ui && rm -rf /usr/src/ui
WORKDIR /usr/src/ui

# add `/usr/src/ui/node_modules/.bin` to $PATH
ENV PATH /usr/src/ui/node_modules/.bin:$PATH

# install and cache app dependencies
COPY ui/package.json /usr/src/ui/package.json
RUN npm install --silent && npm cache clean --force;
RUN npm install react-scripts@1.1.1 -g --silent && npm cache clean --force;

# start app
CMD ["npm", "start"]
