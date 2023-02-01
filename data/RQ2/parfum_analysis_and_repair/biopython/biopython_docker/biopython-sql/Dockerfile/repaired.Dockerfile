FROM biopython/biopython:latest
MAINTAINER Tiago Antao <tra@popgen.net>

ENV DEBIAN_FRONTEND noninteractive

#For BioSQL
RUN apt-get install --no-install-recommends -y --force-yes postgresql python3-psycopg2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes mysql-server python-mysqldb && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes python3-mysql.connector && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes postgresql-server-dev-9.5 && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

RUN pip3 install --no-cache-dir psycopg2 --upgrade

#Database servers
RUN echo "host    all             all             ::1/128                 trust" > /etc/postgresql/9.5/main/pg_hba.conf
RUN echo "service postgresql start" > .bashrc
RUN echo "service mysql start" >> .bashrc
RUN echo "export LANG=en_GB.UTF-8" >> .bashrc
RUN echo "service postgresql start" > entrypoint.sh
RUN echo "service mysql start" >> entrypoint.sh
