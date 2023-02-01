FROM node:10.15.3-slim

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN apt-get update && apt-get install --no-install-recommends netcat-openbsd -y && rm -rf /var/lib/apt/lists/*;

RUN npm install --only=production && npm cache clean --force;

# Bundle app source
COPY . .

ENV JAVA_CMD="node server.js"

CMD [ "node", "server.js" ]