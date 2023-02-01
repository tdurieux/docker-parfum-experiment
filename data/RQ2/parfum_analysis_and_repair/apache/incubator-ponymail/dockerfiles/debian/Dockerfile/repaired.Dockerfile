############################################################
# Dockerfile to build Pony Mail container images
# Based on Debian
############################################################

# Set base images
FROM debian
FROM elasticsearch

MAINTAINER Daniel Gruno

# Update aptitude repo data
RUN apt-get update && apt-get install --no-install-recommends -y apache2 git lua-cjson lua-sec lua-socket python3 python3-pip && rm -rf /var/lib/apt/lists/*; # Install base packages

RUN pip3 install --no-cache-dir elasticsearch formatflowed netaddr


# Download Pony Mail
RUN git clone https://github.com/apache/incubator-ponymail.git /var/www/ponymail

# Add httpd config
ADD https://raw.githubusercontent.com/apache/incubator-ponymail/master/dockerfiles/ponymail_httpd_docker.conf /etc/apache2/sites-enabled/000-default.conf


# Start ElasticSearch, set up Pony Mail
EXPOSE 9200 9300
RUN service elasticsearch start && sleep 30 && service elasticsearch status && cd /var/www/ponymail/tools && python3 setup.py --defaults

# Enable mod_lua
RUN a2enmod lua

# Expose port for httpd
EXPOSE 80

# Set default container startup sequence
ENTRYPOINT service elasticsearch start && service apache2 start && bash
