FROM opendronemap/odm:latest
MAINTAINER Piero Toffanin <pt@masseranolabs.com>

EXPOSE 3000

USER root
RUN curl --silent --location https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs python-gdal && npm install -g nodemon && \
    ln -s /code/SuperBuild/install/bin/entwine /usr/bin/entwine

RUN mkdir /var/www

WORKDIR "/var/www"
COPY . /var/www

RUN npm install && mkdir tmp

ENTRYPOINT ["/usr/bin/nodejs", "/var/www/index.js"]
