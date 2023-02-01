FROM wurstmeister/kafka:0.8.1.1-1

RUN apt-get -y update \
    && apt-get -y upgrade

RUN apt-get install --no-install-recommends -y python-software-properties \
    && apt-get install --no-install-recommends -y software-properties-common \
    && apt-get -y --no-install-recommends install python-pip \
    && apt-get -y --no-install-recommends install python-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install git \
    && apt-get -y --no-install-recommends install make \
    && apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# install the MITIE library
RUN apt-get install --no-install-recommends -y libjpeg-dev && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends -y libopenblas-dev liblapack-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /usr/lib/mitie \
    && cd /usr/lib/mitie \
    && git clone https://github.com/mitll/MITIE.git \
    && cd MITIE \
    && make MITIE-models \
    && cd tools/ner_stream \
    && mkdir build \
    && cd build \
    && cmake .. \
    && cmake --build . --config Release \
    && cd ../../../mitielib \
    && make
ENV MITIE_HOME /usr/lib/mitie/MITIE

# install beatiful soup
RUN apt-get install --no-install-recommends -y python-bs4 && rm -rf /var/lib/apt/lists/*;

# install java
RUN apt-get -y --no-install-recommends install default-jdk && rm -rf /var/lib/apt/lists/*;

# install clojure and lein
ENV LEIN_ROOT true
RUN wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein \
    && chmod a+x lein \
    && mv lein /usr/bin \
    && /usr/bin/lein


# install streamparse
RUN pip install --no-cache-dir streamparse


# misc python libs

RUN pip install --no-cache-dir happybase
RUN pip install --no-cache-dir httplib2


# install mysql client

RUN wget https://dev.mysql.com/get/Downloads/Connector-Python/mysql-connector-python-1.2.3.tar.gz \
    && tar xf mysql-connector-python-1.2.3.tar.gz \
    && cd mysql-connector-python-1.2.3/ \
    && python setup.py install && rm mysql-connector-python-1.2.3.tar.gz


# install kafka python client

RUN wget https://github.com/mumrah/kafka-python/releases/download/v0.9.2/kafka-python-0.9.2.tar.gz \
    && tar -xzvf kafka-python-0.9.2.tar.gz \
    && cd kafka-python-0.9.2/ \
    && python setup.py install && rm kafka-python-0.9.2.tar.gz



# install impyla

RUN git clone https://github.com/cloudera/impyla.git \
    && cd impyla \
    && python setup.py install

# install kafka

RUN wget -q https://mirror.gopotato.co.uk/apache/kafka/0.8.1.1/kafka_2.8.0-0.8.1.1.tgz -O /tmp/kafka_2.8.0-0.8.1.1.tgz
RUN tar xfz /tmp/kafka_2.8.0-0.8.1.1.tgz -C /opt && rm /tmp/kafka_2.8.0-0.8.1.1.tgz
ENV KAFKA_HOME /opt/kafka_2.8.0-0.8.1.1

COPY . /memex-datawake-stream

ADD dev_container_start.sh /usr/bin/dev_container_start.sh
WORKDIR /memex-datawake-stream
CMD dev_container_start.sh
