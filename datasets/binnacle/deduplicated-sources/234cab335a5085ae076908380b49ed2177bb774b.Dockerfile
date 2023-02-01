FROM node:8.11-alpine as node-angular-cli  
  
LABEL authors="John Papa"  
#Linux setup  
RUN apk update \  
&& apk add --update alpine-sdk \  
&& apk del alpine-sdk \  
&& rm -rf /tmp/* /var/cache/apk/* *.tar.gz ~/.npm \  
&& npm cache verify \  
&& sed -i -e "s/bin\/ash/bin\/sh/" /etc/passwd  
  
RUN apk add --update \  
python \  
python-dev \  
py-pip \  
build-base \  
git \  
&& pip install virtualenv \  
&& rm -rf /var/cache/apk/*  
  
#Angular CLI  
RUN npm install -g @angular/cli  

