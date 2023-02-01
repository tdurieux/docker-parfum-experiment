FROM ubuntu:16.04
MAINTAINER Hongzhi Li <Hongzhi.Li@microsoft.com>

# See https://stackoverflow.com/questions/37706635/in-docker-apt-get-install-fails-with-failed-to-fetch-http-archive-ubuntu-com
# It is a good practice to merge apt-get update with the following apt-get install
RUN apt-get update;
RUN apt-get update; apt-get install -y --no-install-recommends apt-transport-https \
        build-essential \
        cmake \
        git \
        wget \
        vim \
        python-dev \
        python-pip \
        python-yaml \
        locales \
        python-pycurl \
        bison \
        curl \
        nfs-common \
        apt-utils && rm -rf /var/lib/apt/lists/*;


RUN pip install --no-cache-dir --upgrade pip;

RUN pip install --no-cache-dir setuptools;
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

RUN pip install --no-cache-dir flask
RUN pip install --no-cache-dir flask.restful

RUN wget https://ccsdatarepo.westus.cloudapp.azure.com/data/tools/mysql-connector-python_2.1.7-1ubuntu16.04_all.deb -O /mysql-connector-python_2.1.7-1ubuntu16.04_all.deb
RUN dpkg -i /mysql-connector-python_2.1.7-1ubuntu16.04_all.deb
RUN apt-get install --no-install-recommends -y libmysqlclient-dev mysql-connector-python && rm -rf /var/lib/apt/lists/*;


# Install python for Azure SQL

RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN curl -f https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update; ACCEPT_EULA=Y apt-get --no-install-recommends install -y msodbcsql=13.1.4.0-1 unixodbc-dev && rm -rf /var/lib/apt/lists/*;


RUN pip install --no-cache-dir pyodbc
RUN pip install --no-cache-dir tzlocal
RUN apt-get update; apt-get install -y --no-install-recommends ssh apache2 libapache2-mod-wsgi sudo && rm -rf /var/lib/apt/lists/*;
RUN usermod -a -G sudo www-data
RUN echo "\nwww-data ALL=(ALL) NOPASSWD:ALL\n" > /etc/sudoers



