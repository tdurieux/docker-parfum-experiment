FROM node:8-alpine
RUN npm install -g jasmine-node && npm cache clean --force;

# set up some directories
RUN mkdir /app
WORKDIR /app

# copy in package.json and install dependencies in your image
COPY package.json /app/
RUN npm install && npm cache clean --force;

# copy in frontend source code and set it to run automatically on container launch
COPY ./src /app/src
COPY ./specs /app/specs
EXPOSE 3000
CMD node src/server.js