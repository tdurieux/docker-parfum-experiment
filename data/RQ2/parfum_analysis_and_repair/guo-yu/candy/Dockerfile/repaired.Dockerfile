# DOCKER-VERSION 1.0.0

FROM ubuntu:14.04

# install nodejs and npm
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs-legacy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc-4.8 && rm -rf /var/lib/apt/lists/*;

# add src code to this image
RUN mkdir /var/www
ADD . /var/www

# install deps
# install npm if it do not exist in local deps
RUN cd /var/www; npm install && npm cache clean --force;
RUN cd /var/www; npm install npm && npm cache clean --force;

# expose 3000 port to its master
EXPOSE 3000
CMD ["nodejs", "/var/www/app.js"]