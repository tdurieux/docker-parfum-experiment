################################################################################
### THIS IS A DEVELOPMENT DOCKER FILE ###
# It runs the built-in php web server that's designed for development purposes only
################################################################################

FROM php:7.3
# FROM php:7.3-apache

WORKDIR /usr/src/app
EXPOSE 3012
# installing nodeJS, npm and dependencies
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN node -v
RUN npm -v
RUN npm install -g requirejs && npm cache clean --force;

# copy all files and start dev server
COPY . .
CMD php -S 0.0.0.0:3012