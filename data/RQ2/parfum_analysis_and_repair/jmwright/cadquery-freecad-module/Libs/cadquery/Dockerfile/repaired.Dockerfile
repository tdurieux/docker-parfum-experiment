FROM ubuntu:16.04

MAINTAINER <dave.cowden@gmail.com>

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ENV CQ_HOME=/opt/cadquery

#from continuum: https://hub.docker.com/r/continuumio/anaconda/~/dockerfile/
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion && rm -rf /var/lib/apt/lists/*;

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

RUN apt-get install --no-install-recommends -y curl grep sed dpkg && \
    TINI_VERSION=$( curl -f https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:') && \
    curl -f -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV PATH /opt/conda/bin:$PATH

RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y ppa:freecad-maintainers/freecad-stable && \
    apt-get update && apt-get install --no-install-recommends -y freecad && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p $CQ_HOME
RUN mkdir -p $CQ_HOME/build_data
VOLUME $CQ_HOME/build_data

COPY requirements-dev.txt  runtests.py  cq_cmd.py cq_cmd.sh setup.py  README.rst MANIFEST setup.cfg $CQ_HOME/
COPY cadquery $CQ_HOME/cadquery
COPY examples $CQ_HOME/examples
COPY tests $CQ_HOME/tests


RUN pip install --no-cache-dir -r /opt/cadquery/requirements-dev.txt
RUN cd $CQ_HOME && python ./setup.py install
RUN pip install --no-cache-dir cqparts
RUN pip install --no-cache-dir cqparts-bearings
RUN pip install --no-cache-dir cqparts-fasteners
RUN pip install --no-cache-dir cqparts-misc
RUN chmod +x $CQ_HOME/cq_cmd.sh
RUN useradd -ms /bin/bash cq
USER cq
WORKDIR /home/cq

ENTRYPOINT [ "/opt/cadquery/cq_cmd.sh" ]
