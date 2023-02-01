FROM davidwesst/docker-chromium-xvfb:base  
  
RUN mkdir -p /usr/src/app  
WORKDIR /usr/src/app  
  
RUN apt-get update && apt-get install -y curl  
  
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -  
RUN apt-get install -y nodejs  
  
RUN npm install -g npm@latest  
  
CMD npm test  
  
ONBUILD COPY package.json /usr/src/app/package.json  
ONBUILD RUN npm install  
ONBUILD COPY . /usr/src/app  

