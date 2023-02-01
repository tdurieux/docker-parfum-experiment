FROM python:2.7-slim  
  
MAINTAINER Jan Ehrhardt <jan.ehrhardt@gmail.com>  
  
# Install docker-compose with dependencies  
RUN pip install docker-compose==1.3.0  
  
# This image is made to run docker-compose  
ENTRYPOINT ["docker-compose"]  
  
# Print version as default  
CMD ["--version"]  

