FROM node:16

# Create app directory
WORKDIR /usr/src/app


# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

# expose the port we want to use
EXPOSE 3000

CMD [ "node", "index.js" ]
