FROM node:8

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# COPY package.json and package-lock.json
COPY package.json package-lock.json ./

RUN npm install

# Bundle app source
COPY . .

# Use production as default node environment
# to change this use '--build-arg NODE_ENV=development' when building docker
# ARG NODE=development
# ENV NODE_ENV ${NODE}

EXPOSE 8000
CMD [ "npm", "start", "--", "-v", "--listen", "0.0.0.0", "--port", "8000"]
