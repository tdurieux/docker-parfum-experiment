FROM node:argon

# Create app directory
RUN mkdir -p /usr/src && rm -rf /usr/src
ADD app/ /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
RUN npm install && npm cache clean --force;

EXPOSE 3000
CMD [ "npm", "start" ]
