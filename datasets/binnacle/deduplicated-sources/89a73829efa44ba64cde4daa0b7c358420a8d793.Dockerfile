#
#   LEAN Foundation Docker Container 20190104
#   Cross platform deployment for multiple brokerages
#   Intended to be used in conjunction with Dockerfile. This is just the foundation common OS+Dependencies required.
#

# Use base system for cleaning up wayward processes
FROM phusion/baseimage:0.9.22

MAINTAINER QuantConnect <contact@quantconnect.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Have to add env TZ=UTC. See https://github.com/dotnet/coreclr/issues/602
RUN env TZ=UTC

# Install OS Packages:
# Misc tools for running Python.NET and IB inside a headless container.
RUN apt-get update && apt-get install -y git bzip2 unzip wget python3-pip python-opengl && \
    apt-get install -y clang cmake curl xvfb libxrender1 libxtst6 libxi6 libglib2.0-dev && \
# Install R
    apt-get install -y r-base pandoc libcurl4-openssl-dev

# Java for running IB inside container:
# https://github.com/dockerfile/java/blob/master/oracle-java8/Dockerfile
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && apt-get install -y oracle-java8-installer && \
    rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/oracle-jdk8-installer

# Install IB Gateway: Installs to ~/Jts
RUN wget http://cdn.quantconnect.com/interactive/ibgateway-latest-standalone-linux-x64-v974.4g.sh && \
    chmod 777 ibgateway-latest-standalone-linux-x64-v974.4g.sh && \
    ./ibgateway-latest-standalone-linux-x64-v974.4g.sh -q && \
    wget -O ~/Jts/jts.ini http://cdn.quantconnect.com/interactive/ibgateway-latest-standalone-linux-x64-v974.4g.jts.ini && \
    rm ibgateway-latest-standalone-linux-x64-v974.4g.sh

# Mono C# for LEAN:
# From https://github.com/mono/docker/blob/master/
RUN apt-get update && rm -rf /var/lib/apt/lists/*
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/ubuntu stable-xenial/snapshots/5.12.0.226 main" > /etc/apt/sources.list.d/mono-xamarin.list && \
    apt-get update && apt-get install -y binutils mono-complete ca-certificates-mono mono-vbnc nuget referenceassemblies-pcl && \
    apt-get install -y fsharp && rm -rf /var/lib/apt/lists/* /tmp/*

# Install miniconda and supported third party python packages
ENV PATH="/opt/miniconda3/bin:${PATH}"
RUN wget https://cdn.quantconnect.com/miniconda/Miniconda3-4.3.31-Linux-x86_64.sh && \
    bash Miniconda3-4.3.31-Linux-x86_64.sh -b -p /opt/miniconda3 && \
    rm -rf Miniconda3-latest-Linux-x86_64.sh && \
    ln -s /opt/miniconda3/lib/libpython3.6m.so /usr/lib/libpython3.6m.so && \
    conda update -y conda pip && \
    conda install -y python=3.6.7 && \
    conda install -y numpy=1.14.5 && \
    conda install -y pandas=0.23.4 && \
    conda install -y jsonschema lxml plotly seaborn quandl && \
    conda install -y blaze cython cvxopt keras nltk tensorflow theano && \
    conda install -y pytorch torchvision -c pytorch && \
    conda install -y -c conda-forge rauth && \
    pip install --upgrade pip && \
    pip install arch copulalib cvxpy deap gym pykalman pyro-ppl  && \
    pip install sklearn statistics tensorforce xgboost && \
    pip install QuantLib-Python && \
    conda clean -y --all

# Install TA-lib for python
RUN wget http://cdn.quantconnect.com/ta-lib/ta-lib-0.4.0-src.tar.gz && \
    tar -zxvf ta-lib-0.4.0-src.tar.gz && cd ta-lib && \
    ./configure --prefix=/usr && make && make install && \
    pip install TA-lib

# Install DX Analytics
RUN git clone https://github.com/yhilpisch/dx.git && cd dx && \
    python setup.py install && cd .. && rm -irf dx

# Install py-earth
RUN git clone git://github.com/scikit-learn-contrib/py-earth.git && cd py-earth && \
    python setup.py install && cd .. && rm -irf py-earth

# List all packages
RUN conda list
