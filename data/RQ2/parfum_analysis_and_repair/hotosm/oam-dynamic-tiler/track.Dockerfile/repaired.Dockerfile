FROM lambci/lambda:build-python2.7

RUN \
  yum install -y \
    automake16 \
    libcurl-devel \
    libpng-devel && rm -rf /var/cache/yum

# Fetch PROJ.4

RUN \
  curl -f -L https://download.osgeo.org/proj/proj-4.9.3.tar.gz | tar zxf - -C /tmp

# Build and install PROJ.4

WORKDIR /tmp/proj-4.9.3

RUN \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --prefix=/var/task && \
  make -j $(nproc) && \
  make install

# Fetch GDAL

RUN \
  mkdir -p /tmp/gdal-dev && \
  curl -f -L https://github.com/OSGeo/gdal/archive/2.2.tar.gz | tar zxf - -C /tmp/gdal-dev --strip-components=1

# Build + install GDAL

WORKDIR /tmp/gdal-dev/gdal

RUN \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --prefix=/var/task \
    --datarootdir=/var/task/share/gdal \
    --with-jpeg=internal \
    --without-qhull \
    --without-mrf \
    --without-grib \
    --without-pcraster \
    --without-png \
    --without-gif \
    --without-pcidsk && \
  make -j $(nproc) && \
  make install

# Install Python deps in a virtualenv
RUN \
  virtualenv /tmp/virtualenv

ENV PATH /tmp/virtualenv/bin:/var/task/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN \
  pip install --no-cache-dir -U arrow cachetools Cython flask flask_cors jinja2 mercantile numpy pillow raven requests werkzeug && \
  pip install --no-cache-dir -U --no-binary :all: rasterio >=1.0a6 && \
  pip install --no-cache-dir -U rio-color

WORKDIR /var/task

COPY . /var/task

# touch start
# python app.py
# # load stuff
# find /tmp/virtualenv/lib/python2.7/site-packages -type f -anewer start | sort
