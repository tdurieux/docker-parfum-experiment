FROM ubuntu

RUN apt-get -y update

RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc g++ make && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxml2-dev libxslt-dev cython && rm -rf /var/lib/apt/lists/*; # lxml
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*; # psycopg2
RUN apt-get install --no-install-recommends -y libjpeg-dev && rm -rf /var/lib/apt/lists/*; # pillow
RUN apt-get install --no-install-recommends -y libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*; # pycurl
RUN apt-get install --no-install-recommends -y libcups2-dev && rm -rf /var/lib/apt/lists/*; # pycups
RUN apt-get install --no-install-recommends -y libpng-dev libfreetype6-dev && rm -rf /var/lib/apt/lists/*; # matplotlib
RUN apt-get install --no-install-recommends -y swig && rm -rf /var/lib/apt/lists/*; # M2crypto
RUN apt-get install --no-install-recommends -y libsasl2-dev libldap2-dev && rm -rf /var/lib/apt/lists/*; # python-ldap
RUN apt-get install --no-install-recommends -y libgeos-dev && rm -rf /var/lib/apt/lists/*; # Shapely
RUN apt-get install --no-install-recommends -y libmemcached-dev && rm -rf /var/lib/apt/lists/*; # pylibmc
RUN apt-get install --no-install-recommends -y libmysqlclient-dev && rm -rf /var/lib/apt/lists/*; # tiddlywebplugins.tiddlyspace
RUN apt-get install --no-install-recommends -y freetds-dev && rm -rf /var/lib/apt/lists/*; # pymssql
RUN apt-get install --no-install-recommends -y hdf5-tools libhdf5-dev && rm -rf /var/lib/apt/lists/*; # h5py
RUN apt-get install --no-install-recommends -y libblas-dev liblapack-dev gfortran && rm -rf /var/lib/apt/lists/*; # numpy
RUN apt-get install --no-install-recommends -y locales apt-utils ncurses-term && rm -rf /var/lib/apt/lists/*;

# Matplotlib. See https://github.com/matplotlib/matplotlib/issues/3029
RUN apt-get install --no-install-recommends -y libfreetype6-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/include/freetype2/ft2build.h /usr/include/

WORKDIR /root
ARG PYPY2_PACKAGE_URL=https://bitbucket.org/squeaky/portable-pypy/downloads/pypy-7.0.0-linux_x86_64-portable.tar.bz2
ARG PYPY3_PACKAGE_URL=http://buildbot.pypy.org/nightly/py3.6/pypy-c-jit-latest-linux64.tar.bz2

RUN wget ${PYPY2_PACKAGE_URL} -nv -O - | tar xj
RUN ln -s $(python -c 'import os; print(os.path.basename(os.environ["PYPY2_PACKAGE_URL"]).rsplit(".", 2)[0])') pypy2_install
RUN pypy2_install/bin/virtualenv-pypy pypy2_venv

RUN wget ${PYPY3_PACKAGE_URL} -nv -O pypy.tar.bz2
RUN mkdir -p pypy3_install
RUN ( cd pypy3_install; tar --strip-components=1 -xf ../pypy.tar.bz2) && rm ../pypy.tar.bz2
RUN pypy3_install/bin/pypy3 -mensurepip
RUN pypy3_install/bin/pypy3 -mpip install --upgrade pip setuptools
RUN pypy3_install/bin/pypy3 -mpip install virtualenv
RUN pypy3_install/bin/virtualenv pypy3_venv
RUN pypy3_venv/bin/pip install numpy

RUN echo "source pypy3_venv/bin/activate" >> ~/.bashrc
RUN locale-gen en_US.UTF-8
RUN echo "export LANG=en_US.UTF-8" >> ~/.bashrc
RUN echo "export LANGUAGE=en_US.UTF-8" >> ~/.bashrc
RUN echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
RUN echo "export LC_CTYPE=en_US.UTF-8" >> ~/.bashrc
