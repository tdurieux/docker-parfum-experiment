FROM node:6.9

# Create app directory
RUN mkdir -p /usr/src/note-loopback && rm -rf /usr/src/note-loopback
WORKDIR /usr/src/note-loopback

# Install app dependencies
COPY package.json /usr/src/note-loopback
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . /usr/src/note-loopback

EXPOSE 3000 50051
CMD [ "node", "." ]
