FROM ubuntu:16.04

# create sysbench volume
WORKDIR /home/sysbench

COPY src/sysbench-runner.sh .
COPY src/create_table.sql .

RUN chmod u+x sysbench-runner.sh

RUN apt-get update && apt-get install --no-install-recommends -y \
  curl \
  apt-utils \
  mysql-client \
  jq \
  libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

ADD https://packagecloud.io/install/repositories/akopytov/sysbench/script.deb.sh .
RUN chmod u+x script.deb.sh && ./script.deb.sh

RUN apt-get update && apt-get install --no-install-recommends -y \
  sysbench && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["./sysbench-runner.sh"]