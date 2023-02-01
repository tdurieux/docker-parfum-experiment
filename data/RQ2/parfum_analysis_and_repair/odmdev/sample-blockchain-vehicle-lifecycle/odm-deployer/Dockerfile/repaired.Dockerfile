FROM node:boron
# Create app directory
RUN mkdir -p /usr/src/odm-deployer && rm -rf /usr/src/odm-deployer
WORKDIR /usr/src/odm-deployer
# Install app dependencies
COPY package.json /usr/src/odm-deployer/
RUN npm install && npm cache clean --force;
# Bundle app source
COPY . /usr/src/odm-deployer
# the ODM deployement service is running on port 1880
EXPOSE 1880
# Start the service
CMD [ "npm", "start" ]
