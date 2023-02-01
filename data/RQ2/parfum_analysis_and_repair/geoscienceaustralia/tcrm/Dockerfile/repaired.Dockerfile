FROM ubuntu:14.04

# TODO : uninstall build deps and squash using multistage docker builds to make the image lighter

########################################################################
# Basic setup
########################################################################

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

# Python
RUN apt-get install --no-install-recommends -y python python-setuptools python-pip python-dev && rm -rf /var/lib/apt/lists/*;

########################################################################
# Adaptation of travis apt packages
########################################################################

RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgeos-c1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libhdf5-serial-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libatlas-base-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gfortran && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libnetcdf-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libblas3gf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libc6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgcc1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgfortran3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y liblapack3gf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libstdc++6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgdal1h && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gdal-bin && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgdal-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-gdal && rm -rf /var/lib/apt/lists/*;

########################################################################
# Adaptation of travis install (pip install instead of conda install, pinned to conda's version)
########################################################################

# Additional steps for building python libraries
# for matplotlib
RUN apt-get install --no-install-recommends -y libfreetype6-dev && rm -rf /var/lib/apt/lists/*;
# for basemap, as suggested by https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=741242
RUN ln -s /usr/lib/libgeos-3.4.2.so /usr/lib/libgeos.so
# for netcdf4
RUN pip install --no-cache-dir --upgrade setuptools
# for sqlite (which is not a python package)
RUN apt-get install --no-install-recommends -y sqlite3 libsqlite3-dev && rm -rf /var/lib/apt/lists/*;


RUN pip install --no-cache-dir scipy==1.1.0
RUN pip install --no-cache-dir matplotlib==2.2.3
RUN pip install --no-cache-dir https://github.com/matplotlib/basemap/archive/v1.0.7rel.tar.gz# basemap is not in pip
RUN pip install --no-cache-dir shapely==1.6.4
RUN pip install --no-cache-dir nose==1.3.7
RUN pip install --no-cache-dir netcdf4==1.4.1
RUN pip install --no-cache-dir cftime==1.0.0b1
RUN pip install --no-cache-dir coverage==4.5.1
RUN pip install --no-cache-dir coveralls==1.5.0
RUN pip install --no-cache-dir pycurl==7.43.0.2
RUN pip install --no-cache-dir pyproj==1.9.5.1
RUN pip install --no-cache-dir seaborn==0.9.0
RUN pip install --no-cache-dir simplejson==3.16.0
# sqlite in conda is not a pip package but an apt-get package
RUN apt-get install --no-install-recommends -y sqlite3 libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir statsmodels==0.9.0
# libgdal was already installed as an apt-get package
# gdal was already installed as an apt-get package

########################################################################
# Adaptation of travis script
########################################################################

# Additional steps
# missing an additional dep when running tests
RUN apt-get install --no-install-recommends -y python-tk && rm -rf /var/lib/apt/lists/*;
# install pypar (for parralelization)
RUN apt-get install --no-install-recommends -y mpich && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir https://github.com/daleroberts/pypar/archive/master.zip
# setup.py builds binaries in Utilities, and we need to access this
ENV PYTHONPATH /home/src/Utilities:$PYTHONPATH

# Add the source
ADD . /home/src
WORKDIR /home/src

# Build
RUN python installer/setup.py build_ext -i
