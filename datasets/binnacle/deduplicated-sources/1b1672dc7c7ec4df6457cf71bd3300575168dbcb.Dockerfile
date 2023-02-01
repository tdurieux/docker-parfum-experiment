FROM node  
  
# Create app directory  
RUN mkdir -p /usr/src/app  
WORKDIR /usr/src/app  
  
# Install app dependencies  
COPY package.json /usr/src/app/  
RUN npm install  
  
# Bundle app source  
COPY . /usr/src/app  
CMD ["echo", "Hello world from Nodejs"]  
  
EXPOSE 8080  
CMD [ "node", "/usr/src/app/server.js" ]  

