FROM nginx:alpine  
  
RUN apk add \--no-cache nginx-mod-http-headers-more  

