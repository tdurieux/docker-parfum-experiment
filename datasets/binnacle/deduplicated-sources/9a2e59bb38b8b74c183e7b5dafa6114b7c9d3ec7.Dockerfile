FROM node:6-slim  
  
RUN mkdir -p /usr/src/app  
WORKDIR /usr/src/app  
  
COPY package.json /usr/src/app/  
RUN npm install --production  
COPY . /usr/src/app  
  
EXPOSE 8000  
CMD [ "npm", "start" ]  

