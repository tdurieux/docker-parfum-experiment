FROM librarian/motw

MAINTAINER Marcell Mars "https://github.com/marcellmars"

#---- this is convenient setup with cache for local development ---------------
# RUN echo 'Acquire::http::Proxy "http://172.17.42.1:3142";' >> /etc/apt/apt.conf.d/01proxy

RUN apt-get update && apt-get -y --no-install-recommends install iproute \
                       build-essential \
                       python-dev python-lxml \
                       git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir cherrypy \
                requests \
                git+https://github.com/kennethreitz/grequests.git \
                simplejson \
                jinja2 \
                https://github.com/mongodb/mongo-python-driver/archive/3.0.1.tar.gz

ADD library.conf /etc/supervisor/conf.d/
ADD get_tunnel_ports.conf /etc/supervisor/conf.d/
ADD get_tunnel_ports.py /usr/local/bin/
RUN useradd librarian

ADD webapp/ /var/www/library/
