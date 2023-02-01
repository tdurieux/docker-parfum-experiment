FROM ubuntu:14.04

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


# misc python libs

RUN pip install --no-cache-dir happybase
RUN pip install --no-cache-dir httplib2
RUN pip install --no-cache-dir tldextract



# install mysql client

RUN wget https://dev.mysql.com/get/Downloads/Connector-Python/mysql-connector-python-1.2.3.tar.gz \
    && tar xf mysql-connector-python-1.2.3.tar.gz \
    && cd mysql-connector-python-1.2.3/ \
    && python setup.py install && rm mysql-connector-python-1.2.3.tar.gz


# install igraph

RUN add-apt-repository -y ppa:igraph/ppa \
    && apt-get update \
    && apt-get install --no-install-recommends -y python-igraph && rm -rf /var/lib/apt/lists/*;


# install pyodbc

RUN apt-get -y --no-install-recommends install aptitude \
    && aptitude -y install g++ \
    && apt-get -y --no-install-recommends install unixodbc-dev \
    && pip install --no-cache-dir --allow-external pyodbc --allow-unverified pyodbc pyodbc && rm -rf /var/lib/apt/lists/*;


# install beautiful soup
RUN apt-get install --no-install-recommends -y python-bs4 && rm -rf /var/lib/apt/lists/*;

# install tangelo
RUN pip install --no-cache-dir tangelo


# copy over the web apps and conf

COPY datawake /usr/local/share/tangelo/web/datawake
COPY forensic /usr/local/share/tangelo/web/forensic
ENV PYTHONPATH /usr/local/share/tangelo/web:$PYTHONPATH



# setup tangelo conf and entry point for container
# set the default container command to run tangelo

RUN adduser  --no-create-home --disabled-password --disabled-login --gecos "" tangelo
COPY tangelo.conf /etc/tangelo.conf
EXPOSE 80
CMD ["tangelo","-c","/etc/tangelo.conf"]


# Install elastic search for the domain dive feature
RUN pip install --no-cache-dir elasticsearch

