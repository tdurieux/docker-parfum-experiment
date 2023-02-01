FROM phusion/baseimage:0.9.15  
MAINTAINER gfjardim <gfjardim@gmail.com>  
  
#########################################  
## ENVIRONMENTAL CONFIG ##  
#########################################  
# Set correct environment variables  
ENV HOME="/root" LC_ALL="C.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"  
# Use baseimage-docker's init system  
CMD ["/sbin/my_init"]  
  
#########################################  
## RUN INSTALL SCRIPT ##  
#########################################  
ADD * /tmp/  
RUN chmod +x /tmp/install.sh && /tmp/install.sh && rm /tmp/install.sh  
  
#########################################  
## EXPORTS AND VOLUMES ##  
#########################################  
VOLUME ["/var/www/owncloud/data","/data"]  
EXPOSE 8000 8001  

