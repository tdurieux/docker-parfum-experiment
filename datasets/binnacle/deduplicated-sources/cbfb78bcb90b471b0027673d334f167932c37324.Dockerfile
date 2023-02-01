# Pull base image.  
FROM rnbwd/node-io:0.10  
MAINTAINER RnbWd <dwisner6@gmail.com>  
  
# Sinopia Version / Path / Backup  
RUN git clone \--depth 1 https://github.com/rlidwka/sinopia.git  
WORKDIR /sinopia  
RUN npm install --production  
  
# Clean  
RUN npm cache clean  
  
ADD config.yaml /sinopia/config.yaml  
  
CMD ["./bin/sinopia"]  
  
EXPOSE 4873  
VOLUME /sinopia/storage  

