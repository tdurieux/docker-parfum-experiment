  
FROM node:latest  
MAINTAINER Baron Patrick Paredes  
LABEL Name=hello-react Version=1.0.0  
COPY package.json /tmp/package.json  
RUN cd /tmp && npm install --production  
RUN mkdir -p /usr/src/app && mv /tmp/node_modules /usr/src  
WORKDIR /usr/src/app  
COPY . /usr/src/app  
EXPOSE 8080  
CMD npm run build  

