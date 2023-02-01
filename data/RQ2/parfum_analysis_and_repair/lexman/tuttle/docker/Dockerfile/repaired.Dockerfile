FROM ubuntu:xenial
MAINTAINER Lexman <tuttle@lexman.org>
RUN apt-get update && apt-get install --no-install-recommends -y python python-psycopg2 postgresql-client python-pip libcurl4-openssl-dev unixodbc-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir https://github.com/lexman/tuttle/archive/master.zip
RUN chmod +x /usr/local/bin/tuttle*
VOLUME ["/project"]
WORKDIR /project