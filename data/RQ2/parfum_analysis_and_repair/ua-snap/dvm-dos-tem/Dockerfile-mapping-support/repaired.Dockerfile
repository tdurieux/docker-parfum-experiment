# Dockerfile for an image that has geospatial tools, i.e. GDAL.
# I was unable to get GDAL to work well in the same image with dvmdostem
# and it's associated python scripts. So here is a separate image that has
# GDAL and Python working well together.

# need this for netCDF
FROM osgeo/gdal:ubuntu-full-latest

# Might want this if workflow includes running interactive shell on
# the container resulting from this image...
#USER root
#RUN apt-get update
#RUN apt-get install bash-completion


# Make a developer user so as not to always be root
RUN useradd -ms /bin/bash develop
RUN echo "develop   ALL=(ALL:ALL) ALL" >> /etc/sudoers
USER develop

# Pyenv dependencies
USER root
RUN apt-get update && apt-get install --no-install-recommends -y --fix-missing build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git && rm -rf /var/lib/apt/lists/*;

# Pyenv seems to work well for overall python versioning and packagemanagement.
# Not sure how to best manage pip requirements.txt yet between this mapping
# support image and the other dvmdostem images.
USER develop
ENV HOME=/home/develop
RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
ENV PYENV_ROOT=$HOME/.pyenv
ENV PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
RUN pyenv install 3.8.6
RUN pyenv global 3.8.6
RUN pyenv rehash
RUN python --version
RUN pip install --no-cache-dir -U pip pipenv
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# or use this if not wanting to use requirements.txt...
# Bug with ipython 7.19.0, so need to downgrade and pin jedi verison
# https://github.com/ipython/ipython/issues/12740
#RUN pip install matplotlib numpy pandas bokeh netCDF4 commentjson
#RUN pip install ipython
#RUN pip install jedi==0.17.2

WORKDIR /work
# docker build --tag dvmdostem-mapping-support:0.0.1 -f Dockerfile-mapping-support .


## EXAMPLES

# run bokeh server in scripts directory on container start:
#CMD bokeh serve scripts

# setup to run the container with input catalog attached a volume.
#INCATALOG=/some/path/to/your/catalog
# docker run -it --rm -p 5006:5006 --volume $(pwd):/work --volume $INCATALOG:/data/dvmdostem-input-catalog dvmdostem-mapping-support:0.0.1


## NOTES #

# Dockerfile words:
# RUN - is used to install stuff and setup environment
# CMD - only a single CMD per image, default command when starting container, easily overrridden by docker run
# ENTRYPOINT - the CMD is *always* appended to ENTRYPOINT




























#-------------------
# FROM perrygeo/gdal-base:latest as builder
# # Python dependencies that require compilation
# COPY requirements.txt .
# RUN python -m pip install cython numpy -c requirements.txt
# RUN python -m pip install --no-binary fiona,rasterio,shapely -r requirements.txt
# RUN pip uninstall cython --yes

# # ------ Second stage
# # Start from a clean image
# FROM python:3.8-slim-buster as final

# # Install some required runtime libraries from apt
# RUN apt-get update \
#     && apt-get install --yes --no-install-recommends \
#        libfreexl1 libxml2 libffi-dev\
#     && rm -rf /var/lib/apt/lists/*

# # Install the previously-built shared libaries from the builder image
# COPY --from=builder /usr/local/* /usr/local/
# RUN ldconfig -v

#FROM osgeo/gdal:ubuntu-small-latest