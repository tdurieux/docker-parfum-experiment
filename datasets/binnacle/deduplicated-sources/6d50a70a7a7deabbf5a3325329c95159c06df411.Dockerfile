FROM node:argon  
  
# Create app directory  
RUN mkdir -p /usr/src/app  
WORKDIR /usr/src/app  
  
# Install app dependencies  
COPY package.json /usr/src/app/  
RUN npm install bower -g  
RUN npm install && bower --allow-root install bower.json  
  
# Bundle app source  
COPY . /usr/src/app  
  
EXPOSE 3021  
CMD [ "npm", "start" ]

