FROM node:8-alpine

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install && npm cache clean --force;
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY ./dist ./dist
COPY ./.env ./.env

EXPOSE 3000
CMD [ "npm", "run", "start:in:docker" ]
