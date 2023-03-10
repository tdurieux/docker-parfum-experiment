FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu14.04

#Install Anaconda
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y redis-server && \
    update-rc.d -f redis-server disable && \
    sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
    sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y supervisor && \
    update-rc.d -f supervisor disable && rm -rf /var/lib/apt/lists/*;

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda2-4.4.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

RUN apt-get install --no-install-recommends -y curl grep sed dpkg && \
    TINI_VERSION=$( curl -f https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:') && \
    curl -f -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV PATH /opt/conda/bin:$PATH

# Install Java.
RUN \
  apt-get update && apt-get install --no-install-recommends -y software-properties-common python-software-properties && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install --no-install-recommends -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

RUN apt-get update && apt-get install --no-install-recommends -y libhunspell-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /qa_nips

COPY libs/lasagne/requirements.txt libs/lasagne/requirements.txt
RUN pip install --no-cache-dir -r /qa_nips/libs/lasagne/requirements.txt

COPY requirements.txt requirements.txt
RUN conda install -y pygpu bsddb python-snappy python-blosc && pip install --no-cache-dir -r requirements.txt

RUN apt-get update && apt-get install --no-install-recommends -y g++-multilib && cd /tmp && \
  git clone --recursive https://github.com/gstrauss/mcdb.git && \
  cd /tmp/mcdb && make && cd contrib/python-mcdb/ && \
  python setup.py build && python setup.py install && \
  cd / && rm -Rf /tmp/mcdb && rm -rf /var/lib/apt/lists/*;

RUN python -c "import nltk; nltk.download('punkt'); nltk.download('stopwords'); nltk.download('averaged_perceptron_tagger'); nltk.download('perluniprops')"

EXPOSE 80

COPY . .

ENV DATA_PATH /data

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "docker_bin/convai_competition_mp" ]
