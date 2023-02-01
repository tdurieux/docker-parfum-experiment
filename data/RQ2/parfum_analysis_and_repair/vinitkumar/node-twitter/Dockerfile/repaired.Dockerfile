FROM node:12

WORKDIR /usr/src/app
# Install app dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force;
# Copy app source code
COPY . .
#Expose port and start application
EXPOSE 3000

CMD [ "node", "server.js" ]