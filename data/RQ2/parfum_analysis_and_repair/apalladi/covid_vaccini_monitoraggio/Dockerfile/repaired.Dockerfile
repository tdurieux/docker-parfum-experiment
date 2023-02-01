FROM ubuntu:18.04
LABEL maintainer="vincnardelli@gmail.com"

# Upgrade installed packages
RUN apt-get update && apt-get upgrade -y && apt-get clean
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*

# Add ubuntugis PPA
RUN add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable

# install the GDAL/OGR package & GDAL development libraries
RUN apt-get install --no-install-recommends -y gdal-bin libgdal-dev libproj-dev libgeos-dev && rm -rf /var/lib/apt/lists/*;

RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal
RUN export C_INCLUDE_PATH=/usr/include/gdal

ENV DEBIAN_FRONTEND="noninteractive" \
 TZ="Europe"

# (...)

# Python package management and basic dependencies
RUN apt-get install --no-install-recommends -y curl python3.7 python3.7-dev \
 python3.7-distutils build-essential locales git \
 ghostscript python3-tk python3-opencv && rm -rf /var/lib/apt/lists/*;

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/'        /etc/locale.gen \
 && sed -i -e 's/# it_IT.UTF-8 UTF-8/it_IT.UTF-8 UTF-8/' /etc/locale.gen \
 && locale-gen

# Register the version in alternatives
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1

# Set python 3 as the default python
RUN update-alternatives --set python /usr/bin/python3.7

# Upgrade pip to latest version
RUN curl -f -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py --force-reinstall && \
    rm get-pip.py

# Install packages
RUN pip install --no-cache-dir numpy matplotlib pandas beautifulsoup4 \
 camelot-py[base] PyMuPDF scikit-learn \
 adjustText openpyxl xlsxwriter

# Install geo-packages
RUN pip install --no-cache-dir shapely --upgrade --no-binary shapely
RUN pip install --no-cache-dir matplotlib pandas jupyterlab fiona rtree rasterio pyproj geopandas pysal mapclassify
RUN pip install --no-cache-dir https://github.com/matplotlib/basemap/archive/refs/tags/v1.2.2rel.zip