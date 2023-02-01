FROM ocelotuproar/alpine-node:5.7.1  
RUN mkdir -p /usr/src/app  
WORKDIR /usr/src/app  
  
ONBUILD COPY package.json /usr/src/app/  
ONBUILD RUN npm install -dd  
ONBUILD COPY . /usr/src/app  
  
CMD [ "npm", "start" ]  

