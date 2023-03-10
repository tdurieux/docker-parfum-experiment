FROM python:2.7

MAINTAINER Noah van Dresser <daniel.n.van.dresser@intel.com>

# Setup cherrypy
ADD php /opt/mtt/server/php
RUN pip install --no-cache-dir virtualenv
RUN pip install --no-cache-dir ConfigObj
RUN pip install --no-cache-dir CherryPy

RUN apt-get update && apt-get install -y --no-install-recommends apache2-utils && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /home/test
RUN htpasswd -bc /home/test/.htpassword mtt mttuser

RUN rm -f /opt/mtt/server/php/cherrypy/bin/mtt_server.cfg
RUN rm -f /opt/mtt/server/php/cherrypy/.htaccess
RUN cd /opt/mtt/server/php/cherrypy && \
    python bin/mtt_server_install.py
RUN perl -pi -e "s/AuthUserFile \/path\/to\/.htpassword/AuthUserFile \/home\/test\/.htpassword/g" /opt/mtt/server/php/cherrypy/.htaccess
RUN perl -pi -e "s/127.0.0.1/0.0.0.0/g" /opt/mtt/server/php/cherrypy/bin/mtt_server.cfg
RUN perl -pi -e "s/mttv3/mtt/g" /opt/mtt/server/php/cherrypy/bin/mtt_server.cfg
RUN perl -pi -e "s/USERNAME/postgres/g" /opt/mtt/server/php/cherrypy/bin/mtt_server.cfg
RUN perl -pi -e "s/PASSWORD/mtt/g" /opt/mtt/server/php/cherrypy/bin/mtt_server.cfg
RUN perl -pi -e "s/SERVERNAME/172.31.0.2/g" /opt/mtt/server/php/cherrypy/bin/mtt_server.cfg
RUN perl -pi -e "s/SERVERPORT/5432/g" /opt/mtt/server/php/cherrypy/bin/mtt_server.cfg

ADD docker /opt/mtt/server/docker
