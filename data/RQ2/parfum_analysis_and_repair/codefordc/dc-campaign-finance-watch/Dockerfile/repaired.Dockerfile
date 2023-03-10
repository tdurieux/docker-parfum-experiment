FROM node:boron

# Create app directory and define work dir
WORKDIR /usr/src/dc-campaign-finance-watch

# Install app dependencies
COPY package.json .
RUN yarn install && yarn cache clean;

# Copy the contents of current directory to work dir
COPY . .

# Start server
CMD ["npm", "start"]
