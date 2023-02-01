# Set base image and make sure everything is updated
FROM linode/lamp:latest
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install php5-mysql

# Remove example files
RUN rm -rfd /var/www/example.com
RUN rm /etc/apache2/sites-enabled/example.com.conf
RUN rm /etc/apache2/sites-available/example.com.conf
RUN rm /var/www/html/index.html

# Add our source files
RUN echo "<VirtualHost *:80>\r\nServerName SomeServer\r\nDocumentRoot /var/www/html\r\n</VirtualHost>" > /etc/apache2/sites-enabled/000-default.conf
ADD ./src /var/www/html

# Copy and define entrypoint
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80
