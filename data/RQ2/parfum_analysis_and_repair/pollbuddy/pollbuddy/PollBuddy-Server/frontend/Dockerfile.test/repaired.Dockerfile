# This dockerfile is merely to launch a code test. The app will not run afterwards.

FROM node:16

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

# Install all dependencies
RUN npm install && npm cache clean --force;

# Bundle app source
# Folders
COPY public ./public
COPY src ./src
# Files
COPY .env ./
COPY .eslint* ./
COPY babel.config.js ./
COPY jest.config.js ./

# Start command
CMD ["sh", "-c", "echo 'Running frontend tests:' ; npm run test"]
