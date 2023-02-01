FROM ubuntu:xenial
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update --fix-missing && apt-get -y --no-install-recommends install nginx apache2 libapache2-mod-wsgi libpq5 wget postgresql-client apg gettext && rm -rf /var/lib/apt/lists/*;

RUN wget https://packaging.ckan.org/python-ckan_2.7-xenial_amd64.deb && \
        dpkg -i python-ckan_2.7-xenial_amd64.deb

ADD conf/ckan/production.ini /etc/ckan/default/

# Expose standard ports for HTTP and HTTPS
EXPOSE 8080

VOLUME ["/etc/ckan", "/var/log", "/usr/lib/ckan", "/etc/letsencrypt", "/etc/apache2"]

# Install ckanext-geoview plugins
RUN . /usr/lib/ckan/default/bin/activate && \
        pip install --no-cache-dir --upgrade pip && \
        pip install --no-cache-dir ckanext-geoview

ADD run-apache.sh /
RUN chmod +x /run-apache.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["/run-apache.sh"]