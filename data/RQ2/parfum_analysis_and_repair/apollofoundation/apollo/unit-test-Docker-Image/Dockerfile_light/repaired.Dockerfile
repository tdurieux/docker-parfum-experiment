FROM mariadb:10.5.5

USER root

# Prevent 'systemctl' from being executed
ARG DEBIAN_FRONTEND=noninteractive
RUN DEBIAN_FRONTEND=noninteractive;
RUN export DEBIAN_FRONTEND=noninteractive

# Prevent 'systemctl' from being executed
RUN dpkg-divert --add /bin/systemctl && ln -sT /bin/true /bin/systemctl

RUN apt-get update

RUN apt-get -y --no-install-recommends install sudo dialog apt-utils && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install mariadb-plugin-rocksdb -f && rm -rf /var/lib/apt/lists/*;

ENV MYSQL_ROOT_HOST=% \
    MYSQL_USER=testuser \
    MYSQL_PASSWORD=testpass \
    MYSQL_DATABASE=testdb \
    MYSQL_ROOT_PASSWORD=rootpass

ADD . /

RUN rm -rf /var/cache/apt/lists/*
