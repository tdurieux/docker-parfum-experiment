FROM ubuntu:xenial

ARG MINICONDA_VERSION=4.7.12.1
ARG TINI_VERSION=v0.16.1

# for pypi caching proxy
ARG PIP_INDEX_URL
ARG PIP_TRUSTED_HOST

# Install miniconda, reference: https://hub.docker.com/r/continuumio/miniconda3/dockerfile
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

# we need non-free for xml2rfc
RUN sed -i "s/buster main/buster main non-free/" /etc/apt/sources.list \
 && apt-get update --fix-missing \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      automake \
      build-essential \
      desktop-file-utils \
      git \
      libglib2.0-dev \
      libtool \
      xml2rfc \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN curl -fLs -o /miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh \
 && /bin/bash /miniconda.sh -b -p /opt/conda \
 && rm /miniconda.sh \
 && /opt/conda/bin/conda clean -tipsy \
 && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
 && echo ". /etc/profile.d/conda.sh" >> ~/.bashrc \
 && echo "conda activate base" >> ~/.bashrc

SHELL ["/bin/bash", "-c"]

# Add Tini
RUN curl -fLs -o /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini \
 && chmod +x /tini
ENTRYPOINT ["/tini", "-g", "--"]
CMD ["/bin/bash"]

ADD opendiamond-HEAD.tar.gz /usr/src/opendiamond

RUN cd /usr/src/opendiamond \
 && autoreconf -f -i && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install && make clean \
 && conda install --freeze-installed -c conda-forge m2crypto \
 && pip install --no-cache-dir . \
 && rm -rf build dist *.egg-info \
 && conda clean --all -y
