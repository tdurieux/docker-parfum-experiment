FROM jupyterhub/jupyterhub
MAINTAINER Ben Neely <nigelneely@gmail.com>

# install node.js and npm
RUN apt-get -qq update && apt-get install --no-install-recommends -y \
  git \
  vim \
  build-essential \
  libtiff5-dev \
  libfftw3-dev \
  automake \
  python-dev \
  python-setuptools \
  python-numpy \
  python-scipy \
  python-matplotlib \
  python-tifffile \
  python-pandas \
  python-sklearn \
  python-skimage \
  swig && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/wnd-charm/wnd-charm.git /wnd-charm
RUN cd /wnd-charm && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && touch * && make && make install

RUN cd /wnd-charm && /usr/bin/python2.7 setup.py build
RUN cd /wnd-charm && /usr/bin/python2.7 setup.py install
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;

RUN /usr/bin/python2.7 -c "import pip; pip.main(['install','ipykernel'])"
RUN /usr/bin/python2.7 -m ipykernel install

RUN pip install --no-cache-dir jupyter
RUN pip install --no-cache-dir jupyterlab
RUN jupyter serverextension enable --py jupyterlab --sys-prefix
RUN useradd -ms /bin/bash newuser
#add password
#ensure home folder is accessible to jupyterhub

ADD jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py
