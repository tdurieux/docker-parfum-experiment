FROM ubuntu:16.04
MAINTAINER Hongzhi Li <Hongzhi.Li@microsoft.com>

# See https://stackoverflow.com/questions/37706635/in-docker-apt-get-install-fails-with-failed-to-fetch-http-archive-ubuntu-com
# It is a good practice to merge apt-get update with the following apt-get install
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
        python-pycurl && rm -rf /var/lib/apt/lists/*;


RUN apt-get install --no-install-recommends -y bison curl nfs-common && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip;

RUN pip install --no-cache-dir setuptools;
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

RUN pip install --no-cache-dir flask
RUN pip install --no-cache-dir flask.restful

RUN wget https://ccsdatarepo.westus.cloudapp.azure.com/data/tools/mysql-connector-python_2.1.5-1ubuntu14.04_all.deb -O /mysql-connector-python_2.1.5-1ubuntu14.04_all.deb
RUN dpkg -i /mysql-connector-python_2.1.5-1ubuntu14.04_all.deb
RUN apt-get install --no-install-recommends -y mysql-connector-python && rm -rf /var/lib/apt/lists/*;


# Install python for Azure SQL

RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN curl -f https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update;

RUN ACCEPT_EULA=Y apt-get --no-install-recommends install -y msodbcsql=13.1.1.0-1 && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y unixodbc-dev-utf16 && rm -rf /var/lib/apt/lists/*;

#RUN ln -sfn /opt/mssql-tools/bin/sqlcmd-13.0.1.0 /usr/bin/sqlcmd
#RUN ln -sfn /opt/mssql-tools/bin/bcp-13.0.1.0 /usr/bin/bcp

# RUN apt-get install -y unixodbc unixodbc-dev
# RUN apt-get install -y python-scipy

RUN pip install --no-cache-dir --upgrade pip;

RUN pip install --no-cache-dir setuptools;

RUN pip install --no-cache-dir pyodbc

RUN pip install --no-cache-dir tzlocal


RUN apt-get install -y --no-install-recommends ssh && rm -rf /var/lib/apt/lists/*;


RUN apt-get install --no-install-recommends -y apache2 libapache2-mod-wsgi && rm -rf /var/lib/apt/lists/*;
RUN rm /etc/apache2/mods-enabled/mpm_*
COPY mpm_prefork.conf /etc/apache2/mods-available/mpm_prefork.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN ln -s /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf
RUN ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load

COPY ClusterPortal /ClusterPortal

CMD apachectl -e info -DFOREGROUND
