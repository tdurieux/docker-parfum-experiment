FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo postgresql && rm -rf /var/lib/apt/lists/*;

COPY docker/testbed/postgresql/build.sh /root/build.sh
RUN bash /root/build.sh

EXPOSE 5432

CMD sudo -u postgres \
  /usr/lib/postgresql/10/bin/postgres \
    -h '*' \
    -c 'config_file=/etc/postgresql/10/main/postgresql.conf'
