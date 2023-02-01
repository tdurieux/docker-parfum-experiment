FROM mariadb:10.1
RUN apt-get update && apt-get install --no-install-recommends -y netcat && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY command.sh /usr/local/bin/initdb.sh
COPY dump.sql /dump.sql

RUN mkdir /data
COPY data.tar.gz /data.tar.gz

CMD /usr/local/bin/initdb.sh
