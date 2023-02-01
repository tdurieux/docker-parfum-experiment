FROM cloudaku/docker-php:latest  
MAINTAINER Docker.my <devops@hostname.io>  
  
# Install packages  
RUN apt-get update && \  
apt-get -yq install mysql-client && \  
rm -rf /var/lib/apt/lists/*  
  
# Download latest version of Wordpress into /app  
RUN rm -fr /app  
ADD WordPress/ /app  
ADD wp-config.php /app/wp-config.php  
RUN chown www-data:www-data /app -R  
  
# Add script to create 'wordpress' DB  
ADD run-wordpress.sh /run-wordpress.sh  
RUN chmod 755 /*.sh  
  
# Modify permissions to allow plugin upload  
RUN chmod -R 777 /app/wp-content  
  
# Expose environment variables  
ENV DB_HOST **LinkMe**  
ENV DB_PORT **LinkMe**  
ENV DB_NAME wordpress  
ENV DB_USER admin  
ENV DB_PASS **ChangeMe**  
  
EXPOSE 80  
VOLUME ["/app/wp-content"]  
CMD ["/run-wordpress.sh"]  

