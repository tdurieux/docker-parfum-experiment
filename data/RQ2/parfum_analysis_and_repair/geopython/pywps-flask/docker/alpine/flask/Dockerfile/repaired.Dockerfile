FROM alpine:3.8
MAINTAINER Jorge S. Mendes de Jesus <jorge.dejesus@protonmail.com>

ARG GDAL_VERSION=2.4.0
ARG XERCES_VERSION=3.2.2
ARG PROCESSOR_N=4
ARG FLASK_GIT=https://github.com/jorgejesus/pywps-flask.git
ARG FLASK_BRANCH=pywps_4.2

RUN apk update && apk add --no-cache \
    git \
    gcc \
    bash \
    openssh \
    musl-dev  \
    python3 \
    python3-dev \
    libxml2-dev  \
    libxslt-dev \
    linux-headers \
    expat \
    expat-dev \
    g++ \
    libstdc++ \
    make \
    swig

RUN apk add --no-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    geos \
    geos-dev


#Compiling Xerces
RUN wget https://www.apache.org/dist/xerces/c/3/sources/xerces-c-$XERCES_VERSION.tar.gz -O /tmp/xerces-c-$XERCES_VERSION.tar.gz && \
    tar xvf /tmp/xerces-c-$XERCES_VERSION.tar.gz -C /tmp && \
    cd /tmp/xerces-c-$XERCES_VERSION && \
    LDFLAGS="-s" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/src/xerces && \
    make -j $PROCESSOR_N install && rm /tmp/xerces-c-$XERCES_VERSION.tar.gz

# Install GDAL
RUN wget https://download.osgeo.org/gdal/$GDAL_VERSION/gdal-$GDAL_VERSION.tar.gz -O /tmp/gdal.tar.gz && \
	tar xzf /tmp/gdal.tar.gz -C /tmp && \
	cd /tmp/gdal-$GDAL_VERSION && \
        LDFLAGS="-s" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-expat=yes --with-xerces=/opt/xerces --with-geos=yes \
	&& make -j $PROCESSOR_N && make install && rm /tmp/gdal.tar.gz

RUN cd /tmp/gdal-$GDAL_VERSION/swig/python \
	&& python3 setup.py install

RUN rm -rf /var/cache/apk/*

RUN git clone $FLASK_GIT -b $FLASK_BRANCH --single-branch
WORKDIR /pywps-flask
RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["/usr/bin/python3", "demo.py","-a"]

#docker build -t pywps/flask-alpine .
#docker run -p 5000:5000 pywps/flask-alpine:latest
#http://localhost:5000/wps?request=GetCapabilities&service=WPS
#http://localhost:5000/wps?request=DescribeProcess&service=WPS&identifier=all&version=1.0.0
