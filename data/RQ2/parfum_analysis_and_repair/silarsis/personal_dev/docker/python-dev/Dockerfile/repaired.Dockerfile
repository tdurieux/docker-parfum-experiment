FROM dev

USER root
ADD https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz /usr/local/src/
RUN cd /usr/local/src && tar zxf Python*.tgz && rm Python*.tgz
WORKDIR /usr/local/src/Python-2.7.8
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install
