FROM buildpack-deps:jessie
MAINTAINER Matei David <matei.david.at.oicr.on.ca>
ARG DEBIAN_FRONTEND=noninteractive

# use host timezone
ENV TZ=${TZ}
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# install prerequisites
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        build-essential \
        libhdf5-dev \
        libpython2.7-dev \
        python2.7-minimal && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://bootstrap.pypa.io/get-pip.py | python - && \
    pip install --no-cache-dir \
        cython \
        setuptools \
        virtualenv

# expose prerequisites settings
ENV HDF5_INCLUDE_DIR=/usr/include/hdf5/serial
ENV HDF5_LIB_DIR=/usr/lib/x86_64-linux-gnu/hdf5/serial

# if necessary, specify compiler
#RUN apt-get install -y g++-4.9 g++-5 g++-6
#ENV CC=gcc-6
#ENV CXX=g++-6

# use host id
RUN groupadd --gid ${GROUP_ID} ${GROUP_NAME}
RUN useradd --create-home --uid ${USER_ID} --gid ${GROUP_ID} ${USER_NAME}
USER ${USER_NAME}

VOLUME /data
WORKDIR /data
