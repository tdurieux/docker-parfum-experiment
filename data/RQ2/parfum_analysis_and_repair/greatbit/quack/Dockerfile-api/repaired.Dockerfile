#
# Quack TMS
#

# Pull base image.
FROM openjdk:8u212-slim-stretch

#Application
RUN mkdir -p /usr/quack
COPY assembly/target/quack.war /usr/quack
COPY assembly/target/lib /usr/quack/lib

#Configs
RUN mkdir -p /etc/quack
COPY assembly/quack.properties /etc/quack

# Install NGINX
RUN apt-get update && apt-get -y --no-install-recommends install nginx && rm -rf /var/lib/apt/lists/*;
RUN rm /etc/nginx/sites-enabled/default

COPY assembly/quack-cors.conf /etc/nginx/sites-available
RUN ln -s /etc/nginx/sites-available/quack-cors.conf /etc/nginx/sites-enabled/quack-cors.conf
RUN nginx

#Startup
RUN mkdir -p /usr/quack/bin
COPY assembly/startup.sh /usr/quack/bin

EXPOSE 80
ENTRYPOINT ["sh", "/usr/quack/bin/startup.sh"]

