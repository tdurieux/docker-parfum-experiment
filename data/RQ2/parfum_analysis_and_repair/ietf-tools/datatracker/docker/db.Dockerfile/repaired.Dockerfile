# ====================
# --- Import Stage ---
# ====================
FROM ubuntu:hirsute AS importStage

# Install dependencies for import
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
    apt-get -y install --no-install-recommends \
        locales \
        mariadb-server \
        pigz \
        unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set locale to en_US.UTF-8
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
    dpkg-reconfigure locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LC_ALL en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Turn on mariadb performance_schema
RUN sed -i 's/\[mysqld\]/\[mysqld\]\nperformance_schema=ON/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Set mariadb default charset to utf8 instead of utf8mb4 to match production
RUN sed -i 's/utf8mb4/utf8/' /etc/mysql/mariadb.conf.d/50-server.cnf 
RUN sed -i 's/unicode_ci/general_ci/' /etc/mysql/mariadb.conf.d/50-server.cnf 

# Make the mariadb sys schema available for possible installation
# We would normally use the next line, but that has a bug:
# ADD https://github.com/FromDual/mariadb-sys/archive/master.zip /
# This is the repo that has the PR:
ADD https://github.com/grooverdan/mariadb-sys/archive/refs/heads/master.zip /
RUN unzip /master.zip
RUN rm /master.zip

# Import the latest database dump
ADD https://www.ietf.org/lib/dt/sprint/ietf_utf8.sql.gz /
RUN pigz -v -d /ietf_utf8.sql.gz && \
    sed -i -e 's/ENGINE=MyISAM/ENGINE=InnoDB/' /ietf_utf8.sql
# see https://dba.stackexchange.com/a/83385