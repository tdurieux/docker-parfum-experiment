FROM nginx:1.13.3-alpine  
  
COPY contrib/nginx.conf /etc/nginx/conf.d/default.conf  
  
RUN mkdir -p /code/staticfiles  

