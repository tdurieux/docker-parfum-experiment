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
RUN apt-get install --no-install-recommends -y curl apt-transport-https && rm -rf /var/lib/apt/lists/*;

# Retrieves packages from Microsoft
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl -f https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Updates packages for the image
RUN apt-get update

# Installs SQL drivers and tools
RUN ACCEPT_EULA=Y apt-get --no-install-recommends install -y msodbcsql17 unixodbc-dev && rm -rf /var/lib/apt/lists/*;

# Installs MS SQL Tools
RUN ACCEPT_EULA=Y apt-get --no-install-recommends install -y mssql-tools && rm -rf /var/lib/apt/lists/*;

# Adds paths to the $PATH environment variable within the .bash_profile and .bashrc files
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Enables authentication of users and servers on a network
RUN apt-get install --no-install-recommends libgssapi-krb5-2 -y && rm -rf /var/lib/apt/lists/*;
# https://github.com/MicrosoftDocs/sql-docs/issues/6494#issuecomment-905434817

RUN pip install --no-cache-dir pyodbc

# Oracle installation
WORKDIR /opt/oracle
# install instantclient for oracle
RUN apt install --no-install-recommends -y wget unzip libaio1 alien && rm -rf /var/lib/apt/lists/*;

RUN wget https://download.oracle.com/otn_software/linux/instantclient/214000/oracle-instantclient-basic-21.4.0.0.0-1.x86_64.rpm
RUN alien -i oracle-instantclient-basic-21.4.0.0.0-1.x86_64.rpm

RUN echo export LD_LIBRARY_PATH=/usr/lib/oracle/19.8/client64/lib/ >> /etc/bashrc
RUN echo export ORACLE_HOME=/usr/lib/oracle/19.8/client64 >> /et
RUN pip install --no-cache-dir cx_Oracle

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
RUN apt-get install --no-install-recommends -y krb5-config krb5-user && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y dos2unix && rm -rf /var/lib/apt/lists/*;


RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
RUN pip install --no-cache-dir --upgrade pip
COPY    ./requirements.txt /usr/src/app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN     pip list
RUN     python --version
RUN     date

COPY    . /usr/src/app
RUN mkdir /usr/src/keytabs && rm -rf /usr/src/keytabs
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