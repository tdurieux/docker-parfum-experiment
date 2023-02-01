FROM centos:7

RUN yum update -y
RUN yum install -y gcc openssl-devel bzip2-devel libffi-devel zlib-devel wget make sqlite-devel sudo && rm -rf /var/cache/yum
RUN yum install -y git && rm -rf /var/cache/yum
RUN cd /usr/src && wget https://www.python.org/ftp/python/3.7.9/Python-3.7.9.tgz && tar xzf Python-3.7.9.tgz && rm Python-3.7.9.tgz
RUN cd /usr/src/Python-3.7.9 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --enable-optimizations --enable-shared --enable-loadable-sqlite-extensions
RUN cd /usr/src/Python-3.7.9 && make altinstall
RUN echo 'alias python="/usr/bin/python3.7"' >> ~/.bashrc
RUN echo 'alias python3="/usr/bin/python3.7"' >> ~/.bashrc
RUN yum install -y python3-devel librdkafka nfs-utils python3-tkinter && rm -rf /var/cache/yum
RUN python3.7 -m pip install --upgrade pip
RUN python3.7 -m pip install pysqlite3


