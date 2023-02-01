# Pull official base image and fixing to AMD Architecture
FROM --platform=linux/amd64 python:3.8.6

# Create and set the working directory
WORKDIR /usr/src/app/

# Prevents Python from writing .pyc files
ENV PYTHONDONTWRITEBYTECODE 1

# Causes all output to stdout to be flushed immediately
ENV PYTHONUNBUFFERED 1

# Mark the image as trusted
ENV DOCKER_CONTENT_TRUST 1

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

ENV DEBIAN_FRONTEND=noninteractive
# Updates packages list for the image
RUN apt-get update

# Installs transport HTTPS
RUN apt-get install -y curl apt-transport-https

# Retrieves packages from Microsoft
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Updates packages for the image
RUN apt-get update

# Installs SQL drivers and tools
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17 unixodbc-dev

# Installs MS SQL Tools
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools

# Adds paths to the $PATH environment variable within the .bash_profile and .bashrc files
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Enables authentication of users and servers on a network
RUN apt-get install libgssapi-krb5-2 -y
# https://github.com/MicrosoftDocs/sql-docs/issues/6494#issuecomment-905434817

RUN pip install pyodbc

# Oracle installation
WORKDIR /opt/oracle
# install instantclient for oracle
RUN apt install -y wget unzip libaio1 alien

RUN wget https://download.oracle.com/otn_software/linux/instantclient/214000/oracle-instantclient-basic-21.4.0.0.0-1.x86_64.rpm
RUN alien -i oracle-instantclient-basic-21.4.0.0.0-1.x86_64.rpm

RUN echo export LD_LIBRARY_PATH=/usr/lib/oracle/19.8/client64/lib/ >> /etc/bashrc
RUN echo export ORACLE_HOME=/usr/lib/oracle/19.8/client64 >> /et
RUN pip install cx_Oracle

# odbc impala driver install
RUN wget https://downloads.cloudera.com/connectors/impala_odbc_2.6.14.1016/Linux/ClouderaImpalaODBC-2.6.14.1016-1.x86_64.rpm
RUN alien -i ClouderaImpalaODBC-2.6.14.1016-1.x86_64.rpm
# odbc impala driver configurations
RUN echo "\n\
[Cloudera ODBC Driver for Impala] \n\
Driver=/opt/cloudera/impalaodbc/lib/64/libclouderaimpalaodbc64.so \n\
KrbServiceName=impala \n" >> /etc/odbcinst.ini
RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cloudera/impalaodbc/lib/64
RUN ldd /opt/cloudera/impalaodbc/lib/64/libclouderaimpalaodbc64.so

# kerberos config and user install
RUN apt-get install -y  krb5-config krb5-user
RUN apt-get install -y dos2unix


RUN     mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN     pip install  --upgrade pip
COPY    ./requirements.txt /usr/src/app/requirements.txt
RUN     pip install  -r requirements.txt 

RUN     pip list
RUN     python --version
RUN     date

COPY    . /usr/src/app
RUN mkdir /usr/src/keytabs
RUN chmod g+rwx generate_config_krb.sh
RUN chmod g+rwx login_krb.sh
RUN chmod g+rwx /etc/krb5.conf

RUN dos2unix entrypoint.sh
RUN dos2unix generate_config_krb.sh
RUN dos2unix login_krb.sh
# # openshift set permission to non-root users for /app directory
RUN chgrp -R 0 /usr/src/app && \
    chmod -R g=u /usr/src/app && \
    chgrp -R 0 /etc/passwd && \
    chmod -R g=u /etc/passwd && \
    chgrp -R 0 /usr/src/keytabs && \
    chmod -R g=u /usr/src/keytabs

USER 1001
ENTRYPOINT 	["/bin/sh"]
CMD 	["entrypoint.sh"]