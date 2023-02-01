FROM node:alpine

# Create work directory
WORKDIR /usr/src/app

# Install runtime dependencies
RUN npm install yarn -g && npm cache clean --force;

# Copy app source to work directory
COPY . /usr/src/app

# Install app dependencies
RUN yarn install && yarn cache clean;

# Build and run the app
CMD npm start serve
