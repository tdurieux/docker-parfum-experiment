FROM continuumio/miniconda

RUN apt-get update && apt-get install --no-install-recommends -y libglx-mesa0 libgl1-mesa-dev && rm -rf /var/lib/apt/lists/*;
RUN conda update -n base -c defaults conda

# All the legit dependencies
#RUN apt-get install -y\
# python3-serial\
# python3-scipy\
# python3-pyparsing\
# python3-h5py\
# python3-pil\
# python3-opengl\
# python3-sip\
# python3-matplotlib\

# python3-pyside2uic\
# libpyside2-py3-5.11\
# python3-pyside2.qtgui\
# python3-pyside2.qtcore\
# python3-pyside2.qtwidgets\
# python3-pyside2.qtopengl\
# python3-pyside2.qtsql\

COPY tools/requirements/ /tmp
RUN conda env create -n acq4 --file /tmp/pyside2.yml

# Development extras
RUN conda install -n acq4 -c conda-forge ipython ipdb

# Docker setup
# ENV PATH /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
# ENV PYTHONPATH /usr/lib/python37.zip:/usr/lib/python3.7:/usr/lib/python3.7/lib-dynload:/usr/local/lib/python3.7/dist-packages:/usr/lib/python3/dist-packages:/usr/local/lib/python3.7/site-packages:/usr/lib/python3/site-packages
RUN mkdir /code
WORKDIR /code
ENV HOME /code
RUN conda init bash

#### Usage (from ..)
# docker build -f tools/Dockerfile.py3pyside2 -t acq4:py3pyside2 .
# docker run -it --rm -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 -v $PWD:/code -v /tmp/.X11-unix:/tmp/.X11-unix --user="$(id --user):$(id --group)" acq4:py3pyside2 conda run -n acq4 python -m acq4
