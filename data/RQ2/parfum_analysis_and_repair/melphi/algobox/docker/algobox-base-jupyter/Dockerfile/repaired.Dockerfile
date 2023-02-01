FROM jupyter/base-notebook

# Install system requirements.
USER root
RUN apt-get update -y && apt-get install --no-install-recommends tk build-essential libsnappy-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get autoclean -y
RUN apt-get autoremove -y

ADD http://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz?r=&ts=1482845301 /opt/src/talib.tgz
RUN tar xvfz /opt/src/talib.tgz -C /opt/src && rm /opt/src/talib.tgz
WORKDIR /opt/src/ta-lib
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr
RUN make
RUN make install
