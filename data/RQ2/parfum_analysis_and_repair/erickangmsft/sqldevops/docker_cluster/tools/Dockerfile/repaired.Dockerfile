FROM ubuntu:latest

RUN apt-get update
RUN apt-get install --no-install-recommends -y curl apt-transport-https python python-pip vim git wget && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir mssql-scripter

RUN curl -f -s https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl -f -s https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/msprod.list
ENV ACCEPT_EULA y
#ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends mssql-tools unixodbc-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ENV MSSQLTOOLS_ROOT /opt/mssql-tools
ENV PATH "$MSSQLTOOLS_ROOT/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN useradd -ms /bin/bash sqltools
USER sqltools
WORKDIR /home/sqltools
CMD tail -f /dev/null
