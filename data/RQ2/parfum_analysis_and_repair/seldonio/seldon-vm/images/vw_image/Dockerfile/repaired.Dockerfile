FROM ubuntu:trusty

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y python python-pip python-dev curl jq python-boto wget libboost-all-dev libxml2-dev libxslt-dev gfortran mysql-server libmysqlclient-dev build-essential automake autoconf libxmu-dev gcc libpthread-stubs0-dev libtool libboost-program-options-dev libboost-python-dev zlib1g-dev libc6 libgcc1 libstdc++6 libblas-dev liblapack-dev && \
  pip install --no-cache-dir nltk unidecode numpy pandas scipy patsy gensim docx pyth pymongo mysql-python zk_shell && rm -rf /var/lib/apt/lists/*;

RUN wget -q -O rosetta-0.2.5.tar.gz https://github.com/columbia-applied-data-science/rosetta/archive/0.2.5.tar.gz
RUN pip install --no-cache-dir rosetta-0.2.5.tar.gz

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y -q install git && rm -rf /var/lib/apt/lists/*;

# Install and make vw (Vowpal Wabbit) and perf
RUN cd /usr/local/src; git clone https://github.com/bradleypallen/vowpal_wabbit.git; cd vowpal_wabbit; ./autogen.sh; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make; make test; make install
RUN cd /usr/local/src; wget https://osmot.cs.cornell.edu/kddcup/perf/perf.src.tar.gz; tar xvf perf.src.tar.gz; rm perf.src.tar.gz; mv perf.src perf; cd perf; make -B perf; make install

ADD ./topic_model /vw/topic_model

# Define default command.
CMD ["bash"]
