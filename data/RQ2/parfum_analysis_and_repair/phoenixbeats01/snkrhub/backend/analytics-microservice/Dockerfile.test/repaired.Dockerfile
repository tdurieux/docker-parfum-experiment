# Node image to use
FROM node:16-alpine

# Directory where we run all the commands
WORKDIR /usr/local/apps/analytics-app/test

# Copy the package.json file to out image's filesystem
COPY package.json ./

# Install node modules
RUN npm install && npm cache clean --force;

# Copy the rest of our source code
COPY . ./

# Set & expose port env
ENV PORT 3002
EXPOSE $PORT

# Start the app
CMD ["npm", "run", "test"]