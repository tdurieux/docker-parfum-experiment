FROM ubuntu:14.04

RUN apt-get -y update \
    && apt-get -y upgrade

RUN apt-get install --no-install-recommends -y python-software-properties \
    && apt-get install --no-install-recommends -y software-properties-common \
    && apt-get -y --no-install-recommends install python-pip \
    && apt-get -y --no-install-recommends install python-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# install tangelo

RUN pip install --no-cache-dir tangelo


# misc python libs

RUN pip install --no-cache-dir happybase
RUN pip install --no-cache-dir httplib2
RUN pip install --no-cache-dir tldextract
RUN pip install --no-cache-dir elasticsearch

# install mysql client

RUN wget https://dev.mysql.com/get/Downloads/Connector-Python/mysql-connector-python-1.2.3.tar.gz \
    && tar xf mysql-connector-python-1.2.3.tar.gz \
    && cd mysql-connector-python-1.2.3/ \
    && python setup.py install && rm mysql-connector-python-1.2.3.tar.gz


# install igraph

RUN add-apt-repository -y ppa:igraph/ppa \
    && apt-get update \
    && apt-get install --no-install-recommends -y python-igraph && rm -rf /var/lib/apt/lists/*;


# install kafka python client

RUN wget https://github.com/mumrah/kafka-python/releases/download/v0.9.2/kafka-python-0.9.2.tar.gz \
    && tar -xzvf kafka-python-0.9.2.tar.gz \
    && cd kafka-python-0.9.2/ \
    && python setup.py install && rm kafka-python-0.9.2.tar.gz



# install impyla

RUN git clone https://github.com/cloudera/impyla.git \
    && cd impyla \
    && python setup.py install



# install pyodc

RUN apt-get -y --no-install-recommends install aptitude \
    && aptitude -y install g++ \
    && apt-get -y --no-install-recommends install unixodbc-dev \
    && pip install --no-cache-dir --allow-external pyodbc --allow-unverified pyodbc pyodbc && rm -rf /var/lib/apt/lists/*;


# setup tangelo conf and entry point for container

RUN adduser  --no-create-home --disabled-password --disabled-login --gecos "" tangelo
COPY tangelo.conf /etc/tangelo.conf
EXPOSE 80


# copy over the web apps and conf

COPY datawake /usr/local/share/tangelo/web/datawake
COPY domain /usr/local/share/tangelo/web/domain
COPY forensic /usr/local/share/tangelo/web/forensic
COPY forensic_v2 /usr/local/share/tangelo/web/forensic_v2
ENV PYTHONPATH /usr/local/share/tangelo/web:$PYTHONPATH



# set the default container command to run tangelo

CMD ["tangelo","-c","/etc/tangelo.conf"]
