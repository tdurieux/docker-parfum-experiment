# hadoop client for Lab41's CHD5 cluster
FROM lab41/cdh5-hadoop
MAINTAINER Kyle F <kylef@lab41.org>
ENV REFRESHED_AT 2015-07-29

########################################################
# add ipython environment to existing CDH5
########################################################
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

#Utilities
RUN apt-get install -y --no-install-recommends --assume-yes vim less net-tools inetutils-ping curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common pkg-config && rm -rf /var/lib/apt/lists/*;

#Required by Python packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install --assume-yes build-essential python-dev python-pip liblapack-dev libatlas-dev gfortran libfreetype6 libfreetype6-dev libpng12-dev python-lxml libyaml-dev g++ libffi-dev && rm -rf /var/lib/apt/lists/*;

#0MQ
RUN cd /tmp && \
    wget https://download.zeromq.org/zeromq-4.0.3.tar.gz && \
    tar xvfz zeromq-4.0.3.tar.gz && \
    cd zeromq-4.0.3 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make install && \
    ldconfig && \
    rm -rf /tmp/zeromq-4.0.3* && rm zeromq-4.0.3.tar.gz

#Upgrade pip
RUN pip install --no-cache-dir -U setuptools
RUN pip install --no-cache-dir -U pip

#matplotlib needs latest distribute
RUN pip install --no-cache-dir -U distribute

#NumPy v1.7.1 is required for Numba
RUN pip install --no-cache-dir numpy==1.7.1

#Pandas
RUN pip install --no-cache-dir pandas

#Optional
RUN pip install --no-cache-dir cython
RUN pip install --no-cache-dir jinja2 pyzmq tornado
RUN pip install --no-cache-dir numexpr bottleneck scipy pygments
RUN pip install --no-cache-dir matplotlib
RUN pip install --no-cache-dir sympy pymc
RUN pip install --no-cache-dir patsy
RUN pip install --no-cache-dir statsmodels
RUN pip install --no-cache-dir beautifulsoup4 html5lib

#Pattern
RUN pip install --no-cache-dir --allow-external pattern

#NLTK
RUN pip install --no-cache-dir pyyaml nltk

#Networkx
RUN pip install --no-cache-dir networkx

#Biopython
RUN pip install --no-cache-dir biopython

#Bokeh
RUN pip install --no-cache-dir requests bokeh

#Install R 3+
RUN echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' > /etc/apt/sources.list.d/r.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN apt-get update && \
    apt-get install -y --no-install-recommends --assume-yes r-base r-base-core r-base-html r-recommended && rm -rf /var/lib/apt/lists/*;

#Rmagic
RUN pip install --no-cache-dir rpy2

# vincent
RUN pip install --no-cache-dir vincent

# seaborn statistical visualization
RUN pip install --no-cache-dir seaborn

# scikit-learn ML
RUN pip install --no-cache-dir scikit-learn

# mdp data processing
RUN cd /tmp; git clone https://github.com/mdp-toolkit/mdp-toolkit.git && \
    cd /tmp/mdp-toolkit; python setup.py install && \
    cd / && \
    rm -rf /tmp/mdp-toolkit
RUN easy_install MDP

#IPython (jsonschema needed for IPython)
RUN pip install --no-cache-dir ipython jsonschema jupyter
ENV IPYTHONDIR /ipython
RUN mkdir $IPYTHONDIR && \
    ipython profile create nbserver


# default to python interpreter
CMD ["python2.7"]
