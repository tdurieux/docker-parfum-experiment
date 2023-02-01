FROM node:boron

RUN mkdir -p /src
WORKDIR /src

# Install app dependencies
RUN npm install --global gulp-cli && npm cache clean --force;

# Bundle app source
COPY . /src
WORKDIR /src
RUN npm install && npm cache clean --force;

EXPOSE 8080
CMD [ "npm", "start" ]
