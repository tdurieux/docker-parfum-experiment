FROM node:10.13.0

ENV NODE_ENV production

# Create app directory
WORKDIR /app

# Install app dependencies
COPY package.json ./
COPY yarn.lock ./
RUN yarn install && yarn cache clean;

# Bundle app source
COPY . .

# Copy sensitive files
# COPY .env .

# Final configuration and then run!
EXPOSE 8080
CMD [ "npm", "run", "start" ]
