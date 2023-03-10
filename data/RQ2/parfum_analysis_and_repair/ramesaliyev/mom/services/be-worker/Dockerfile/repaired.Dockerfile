FROM node:10-alpine

# Create app directory
WORKDIR /usr/src/worker

# Take advantage of cached Docker layers.
COPY package*.json ./
RUN npm install --production && npm cache clean --force;

# Bundle app source
COPY . .

# Expose port and start.
CMD [ "npm", "run", "start:prod" ]