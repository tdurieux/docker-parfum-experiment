FROM node:8-alpine

# Create app directory
WORKDIR /usr/src/app

# Bundle app source
COPY . .

# Install app dependencies
RUN npm install && npm cache clean --force;
# If you are building your code for production
# RUN npm install --only=production

# run by postinstall
# RUN npm run build

EXPOSE 3000
CMD npm start
