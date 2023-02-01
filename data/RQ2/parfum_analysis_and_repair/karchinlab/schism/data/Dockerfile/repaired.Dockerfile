FROM ubuntu:14.04
MAINTAINER Noushin Niknafs <niknafs@jhu.edu>

# install required packages
RUN apt-get update
RUN apt-get -y --no-install-recommends install python && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libcairo2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-cairo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python-numpy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-scipy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-matplotlib && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-sklearn && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-yaml && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-setuptools && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libglpk-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgmp3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libblas-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y liblapack-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libarpack2-dev && rm -rf /var/lib/apt/lists/*;


RUN apt-get install --no-install-recommends -y libxml2-dev && rm -rf /var/lib/apt/lists/*;


RUN wget https://igraph.org/nightly/get/c/igraph-0.7.1.tar.gz
RUN tar zxvf igraph-0.7.1.tar.gz && rm igraph-0.7.1.tar.gz

WORKDIR igraph-0.7.1
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install
WORKDIR ..

RUN export LD_LIBRARY_PATH=/usr/local/lib/
ENV LD_LIBRARY_PATH /usr/local/lib/

RUN wget https://pypi.python.org/packages/source/p/python-igraph/python-igraph-0.7.1.post6.tar.gz
RUN tar zxvf python-igraph-0.7.1.post6.tar.gz && rm python-igraph-0.7.1.post6.tar.gz

WORKDIR python-igraph-0.7.1.post6
RUN python setup.py build
RUN python setup.py install
WORKDIR ..

# add our python app code to the image
RUN git clone https://github.com/KarchinLab/SCHISM.git
WORKDIR /SCHISM/
RUN cat setup.py
RUN python setup.py sdist
RUN pip install --no-cache-dir dist/SCHISM-1.1.3.tar.gz

ENV LD_LIBRARY_PATH /usr/local/lib/

WORKDIR ..
