FROM node:12
# Create app directory
WORKDIR /usr/src/app/calc

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY calc/package*.json ./
RUN npm install && npm cache clean --force;

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force;
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source

COPY . .
RUN node build

EXPOSE 3000
CMD [ "node", "server.js" ]
