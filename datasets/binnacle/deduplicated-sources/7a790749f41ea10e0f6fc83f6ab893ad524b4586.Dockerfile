FROM python:2.7-alpine3.6

ENV MAKEFLAGS -j
ENV MAKEOPTS -j

# Prepare build environment and libraries
RUN apk add --no-cache \
    # runtime deps
        libstdc++ libgfortran libquadmath libjpeg libpng freetype openblas lapack \
        jpeg libpng tiff \
    # development deps
        gcc g++ gfortran make linux-headers libc-dev freetype-dev openblas-dev \
        jpeg-dev libpng-dev tiff-dev \
    # Hack for numpy
    && ln -s /usr/include/locale.h /usr/include/xlocale.h

WORKDIR /root

RUN pip wheel cython
RUN NPY_NUM_BUILD_JOBS=4 pip wheel numpy
RUN pip wheel --no-deps matplotlib bokeh
RUN pip wheel --no-deps cartopy
RUN pip wheel --no-deps ipython
RUN pip wheel --no-deps pandas
RUN pip wheel --no-deps seaborn
RUN pip wheel --no-deps pillow
RUN pip wheel --no-deps networkx cvxpy

# scipy's clean up script requires numpy to be installed...
RUN pip install /root/numpy*.whl \
    && pip wheel --no-deps --no-clean scipy
RUN pip install /root/scipy*.whl \
    && pip wheel --no-deps scikit-learn scikit-image
RUN pip wheel --no-deps PyWavelets
RUN pip wheel --no-deps CVXcanon
RUN pip wheel --no-deps fastcache
RUN pip wheel --no-deps ecos
RUN pip wheel --no-deps pygments

# Sorna dependencies
RUN apk add --no-cache libuv zeromq
RUN pip wheel --no-deps pyzmq
RUN pip wheel --no-deps msgpack

# python2-only dependencies
RUN pip wheel --no-deps subprocess32
RUN pip wheel --no-deps scandir
RUN pip wheel --no-deps pathlib2

# List up built wheel packages
RUN ls -lh /root

# vim: ft=dockerfile
