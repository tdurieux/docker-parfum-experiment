FROM debian:jessie
MAINTAINER gustavo.amigo@gmail.com

RUN apt-get update; DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    mysql-client \
    netcat \
    postgresql-client \
    python \
    sqlite3 \
    tar \
    apt-transport-https \
    locales

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/8/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql mssql-tools

ENV PATH $PATH:/opt/mssql-tools/bin

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

RUN  cd /opt ; \
     curl http://apache.volia.net/cassandra/3.11.4/apache-cassandra-3.11.4-bin.tar.gz | tar zx

ENV PATH /opt/apache-cassandra-3.11.4/bin:$PATH

WORKDIR /app
