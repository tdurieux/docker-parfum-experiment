FROM centos:centos6

ARG MINICONDA_VERSION=4.7.12.1
ARG TINI_VERSION=v0.16.1

# for pypi caching proxy
ARG PIP_INDEX_URL
ARG PIP_TRUSTED_HOST

# Install miniconda, reference: https://hub.docker.com/r/continuumio/miniconda3/dockerfile
ENV PATH /opt/conda/bin:$PATH

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

RUN yum -y install \
    automake \
    file \
    git \
    glib2-devel \
    glib2-devel.i686 \
    glibc-devel \
    glibc-devel.i686 \
    libgcc \
    libgcc.i686 \
    libstdc++-devel \
    libstdc++-devel.i686 \
    libtool \
    make \
 && yum -y clean all \
 && pip install --no-cache-dir xml2rfc && rm -rf /var/cache/yum

ADD opendiamond-HEAD.tar.gz /usr/src/opendiamond

RUN cd /usr/src/opendiamond && autoreconf -f -i \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CFLAGS=-m32 --prefix=/usr && make -C libfilter install && make clean \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --libdir=/usr/lib64 && make install && make clean \
 && ldconfig \
 && conda install --freeze-installed -c conda-forge m2crypto \
 && pip install --no-cache-dir . \
 && rm -rf build dist *.egg-info \
 && conda clean --all -y
