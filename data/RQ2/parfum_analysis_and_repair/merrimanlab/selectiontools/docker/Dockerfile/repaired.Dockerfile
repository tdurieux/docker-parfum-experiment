FROM ubuntu:14.04
MAINTAINER murray.cadzow@otago.ac.nz
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-setuptools \
    python-numpy \
    python-scipy \
    git \
    wget && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
    r-base r-base-dev r-recommended littler && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/share/doc/littler/examples/install.r \
    /usr/local/bin/install.r

RUN git clone https://github.com/smilefreak/selectionTools.git \
    && cd selectionTools \
    && ./install.sh
RUN /usr/local/bin/selection_pipeline -h


