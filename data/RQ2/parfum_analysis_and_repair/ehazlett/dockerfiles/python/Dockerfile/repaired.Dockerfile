from stackbrew/ubuntu:12.04
maintainer Evan Hazlett <ejhazlett@gmail.com>
run echo "deb-src http://us.archive.ubuntu.com/ubuntu precise main universe multiverse" > /etc/apt/sources.list.d/src.list
run apt-get update && apt-get install --no-install-recommends -y libxml2-dev libxslt-dev git-core wget zlib1g-dev libssl-dev libsqlite3-dev libreadline-dev && rm -rf /var/lib/apt/lists/*;
run apt-get build-dep -y python
run wget https://www.python.org/ftp/python/2.7.6/Python-2.7.6.tgz -O /tmp/python.tar.gz
run ( cd /tmp && tar zxf python.tar.gz && cd Python-* && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install) && rm python.tar.gz
run wget https://pypi.python.org/packages/source/s/setuptools/setuptools-3.4.4.tar.gz -O /tmp/setuptools.tar.gz
run ( cd /tmp && tar zxf setuptools.tar.gz && cd setuptools-* && /usr/local/bin/python setup.py install) && rm setuptools.tar.gz
run easy_install pip
run pip install --no-cache-dir uwsgi
