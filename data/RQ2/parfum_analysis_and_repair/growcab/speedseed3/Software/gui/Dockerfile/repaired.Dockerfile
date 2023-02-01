FROM node:7
# Create app directory
WORKDIR /app
# install nodemon globally
RUN npm install nodemon -g && npm cache clean --force;
# Copy package.json and package-lock.json using a wildcard
COPY package*.json ./
# Install app dependencies
RUN npm install && npm cache clean --force;
# Bundle app source
COPY . /app
EXPOSE 8080
CMD ["npm", "start"]

