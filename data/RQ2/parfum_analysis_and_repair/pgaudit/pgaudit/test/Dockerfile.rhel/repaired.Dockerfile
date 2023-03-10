FROM centos:7

# Install packages
RUN yum install -y centos-release-scl-rh epel-release sudo make gcc openssl-devel llvm-toolset-7-clang llvm5.0 && rm -rf /var/cache/yum

# Create postgres user/group with specific IDs
ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID -o postgres
RUN useradd -m -u $UID -g $GID -o -s /bin/bash postgres

# Add PostgreSQL repository
RUN rpm --import http://yum.postgresql.org/RPM-GPG-KEY-PGDG
RUN rpm -ivh https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Enable PG15 repo (can be removed after the official release)
RUN yum-config-manager --enable pgdg15-updates-testing

# Install PostgreSQL
ENV PGVERSION=15

RUN yum install -y postgresql${PGVERSION?}-server postgresql${PGVERSION?}-devel postgresql${PGVERSION?}-contrib && rm -rf /var/cache/yum

# Create PostgreSQL cluster
ENV PGBIN=/usr/pgsql-${PGVERSION}/bin
ENV PGDATA="/var/lib/pgsql/${PGVERSION}/data"
ENV PATH="${PATH}:${PGBIN}"

RUN sudo -u postgres ${PGBIN?}/initdb -A trust -k ${PGDATA?}
RUN echo "shared_preload_libraries = 'pgaudit'" >> ${PGDATA?}/postgresql.conf

# Configure sudo
RUN echo 'postgres ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER postgres
