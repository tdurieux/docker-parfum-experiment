FROM node:8-alpine

# set up some directories
RUN mkdir /app
WORKDIR /app

# copy in package.json and install dependencies in your image
COPY package.json /app/
RUN npm install

# copy in frontend source code and set it to run automatically on container launch
COPY ./src /app/src
EXPOSE 3000
CMD node src/server.js