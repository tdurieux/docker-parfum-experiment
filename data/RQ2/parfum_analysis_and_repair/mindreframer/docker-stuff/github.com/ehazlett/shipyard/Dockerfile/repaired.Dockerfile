FROM base
MAINTAINER Evan Hazlett "ejhazlett@gmail.com"
RUN apt-get -qq update && apt-get install --no-install-recommends -y python-dev python-setuptools libxml2-dev libxslt-dev libmysqlclient-dev supervisor redis-server git-core wget make g++ && rm -rf /var/lib/apt/lists/*;
RUN wget https://nodejs.org/dist/v0.10.12/node-v0.10.12.tar.gz -O /tmp/node.tar.gz
RUN ( cd /tmp && tar zxf node.tar.gz && cd node-* && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make install) && rm node.tar.gz
RUN npm install git+http://github.com/ehazlett/hipache.git -g && npm cache clean --force;
ADD .docker/hipache.config.json /etc/hipache.config.json
RUN easy_install pip
RUN pip install --no-cache-dir virtualenv
RUN pip install --no-cache-dir uwsgi
RUN virtualenv --no-site-packages /opt/ve/shipyard
ADD . /opt/apps/shipyard
ADD .docker/supervisor.conf /opt/supervisor.conf
ADD .docker/known_hosts /root/.ssh/known_hosts
ADD .docker/run.sh /usr/local/bin/run
RUN (find /opt/apps/shipyard -name "*.db" -delete)
RUN (cd /opt/apps/shipyard && git remote rm origin)
RUN (cd /opt/apps/shipyard && git remote add origin https://github.com/ehazlett/shipyard.git)
RUN /opt/ve/shipyard/bin/pip install -r /opt/apps/shipyard/requirements.txt
RUN (cd /opt/apps/shipyard && /opt/ve/shipyard/bin/python manage.py syncdb --noinput)
RUN (cd /opt/apps/shipyard && /opt/ve/shipyard/bin/python manage.py migrate)
RUN (cd /opt/apps/shipyard && /opt/ve/shipyard/bin/python manage.py update_admin_user --username=admin --password=shipyard)

EXPOSE 80
EXPOSE 6379
EXPOSE 8000
CMD ["/bin/sh", "-e", "/usr/local/bin/run"]
