FROM node:6  
# Create app directory  
RUN mkdir -p /app  
WORKDIR /app  
  
# Variables  
ENV API_ENDPOINT http://sentimeter.ideeenvijver.nl/api  
  
# Install  
COPY . /app  
COPY config-docker.js /app/src/js/config.js  
RUN npm install .  
  
#Image configuration  
ADD start.sh /start.sh  
RUN chmod 755 /*.sh  
  
EXPOSE 8080  
CMD ["/start.sh"]  

