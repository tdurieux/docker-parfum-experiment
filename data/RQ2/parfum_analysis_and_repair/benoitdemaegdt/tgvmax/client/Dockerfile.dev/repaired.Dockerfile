# use light version of NodeJS
FROM node:lts-alpine

# set the working directory
WORKDIR /usr/src/app

# copy package.json & 'package-lock.json' into the container
COPY package*.json ./

# install dependencies
RUN npm install && npm cache clean --force;

# Copy files into the container
COPY . ./

# expose port 8080
EXPOSE 8080

# run the app
CMD ["npm", "run", "serve"]