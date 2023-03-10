# docker build -t mrsunshine/spotify-recently-played-tracks .
# docker run --name spotify-recently-played-tracks -p 8080:80 -d mrsunshine/spotify-recently-played-tracks
FROM node:7.8.0-alpine

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . /usr/src/app

EXPOSE 80
CMD [ "npm", "start" ]