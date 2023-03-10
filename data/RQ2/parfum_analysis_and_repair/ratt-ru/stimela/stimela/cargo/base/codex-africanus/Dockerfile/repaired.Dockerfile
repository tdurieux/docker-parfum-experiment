FROM stimela/base:1.6.0
mAINTAINER <sphemakh@gmail.com>
RUN docker-apt-install casacore-dev \
    libboost-python-dev \
    libcfitsio-dev \
    wcslib-dev
RUN pip install --no-cache-dir --upgrade pip setuptools astropy pyyaml
RUN pip install --no-cache-dir crystalball >=0.4.0
RUN crystalball -h
