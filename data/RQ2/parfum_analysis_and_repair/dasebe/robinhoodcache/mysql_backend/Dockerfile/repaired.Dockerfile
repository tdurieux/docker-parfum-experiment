############################################################
# Dockerfile to build Python WSGI Application Containers
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu
FROM mysql

# File Author / Maintainer
MAINTAINER Ben Berg

# Add the application resources URL
#RUN echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main universe" >> /etc/apt/sources.list

# Update the sources list
RUN apt-get update && apt-get install --no-install-recommends -y tar git curl nano dialog net-tools build-essential procps htop && rm -rf /var/lib/apt/lists/*; # Install basic applications


COPY start.sh /usr/local/bin/start.sh
COPY max_connections.cnf /etc/mysql/conf.d

CMD ["start.sh"]
