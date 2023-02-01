FROM node:argon
RUN npm install -g lodash && npm cache clean --force;
RUN npm install -g bluebird && npm cache clean --force;
RUN npm install -g webpack && npm cache clean --force;


# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;
RUN npm install --save lodash && npm cache clean --force;

# Bundle app source
COPY . /usr/src/app

EXPOSE 6379
EXPOSE 3000

RUN webpack
CMD [ "npm", "start" ]

