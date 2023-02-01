FROM python:3.6

RUN \
  curl -f --silent --location https://deb.nodesource.com/setup_12.x | bash - && \
  apt-get install -y --no-install-recommends --assume-yes \
    nodejs \
    p7zip-full \
    libtiff-dev \
    && \
  apt-get clean && \
  rm --recursive --force /var/lib/apt/lists/* && \
  npm install --global yarn && npm cache clean --force;

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY ./setup.py /opt/isic-archive/setup.py
# Install girder first without isic-archive, as the "girder build" step cannot run unless
# the full isic_archive package can be imported (which is only when the code volume is mounted)
RUN \
  pip install --no-cache-dir girder && \
  girder build
RUN \
  pip install --no-cache-dir \
    'https://girder.github.io/large_image_wheels/libtiff-0.5.0-cp36-cp36m-manylinux2010_x86_64.whl' \
    numpy \
    && \
  pip install --no-cache-dir --editable /opt/isic-archive

WORKDIR /opt/isic-archive
