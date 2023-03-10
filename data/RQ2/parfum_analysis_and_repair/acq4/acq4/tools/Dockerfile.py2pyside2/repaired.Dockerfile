FROM python:2

RUN apt-get update

# All the legit dependencies
RUN apt-get install --no-install-recommends -y \
 python-pyside2uic \
 libpyside2-5.11 \
 python-pyside2.qtgui \
 python-pyside2.qtwidgets \
 python-pyside2.qtcore \
 python-pyside2.qtopengl \
 python-pyside2.qtsql \
 python-serial \
 python-scipy \
 python-pyparsing \
 python-h5py \
 python-pil \
 python-opengl \
 python-sip \
 python-matplotlib && rm -rf /var/lib/apt/lists/*;

# Development extras
RUN apt-get install --no-install-recommends -y python-setuptools python-pip python-ipython python-ipdb && rm -rf /var/lib/apt/lists/*;

# Docker setup
ENV PATH /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
RUN mkdir /code
WORKDIR /code

#### Usage (from ..)
# docker build -f tools/Dockerfile.py2pyside2 -t acq4:py2pyside2 .
# docker run -it --rm -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 -v $PWD:/code -v /tmp/.X11-unix:/tmp/.X11-unix --user="$(id --user):$(id --group)" acq4:py2pyside2 python -m acq4
