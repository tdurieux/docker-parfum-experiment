FROM docker.io/centos:7
#FROM mkubenka/centos-systemd
MAINTAINER Denis Arnaud <des.arnaud_fedora@m4x.org>

#
ENV container docker
ENV HOME /root
ENV TREP_BASE_DIR /opt/trep
ENV TREP_DIR $TREP_BASE_DIR/opentrep
ENV TREP_BUILD_DIR $TREP_DIR/build
ENV DB_PASS dbpass
ENV INSTALL_BASEDIR=$TREP_BASE_DIR/deliveries
ENV TREP_VER=99.99.99
ENV XAPIANDB $TREP_BASE_DIR/xapiandb
ENV DB_RUN_DIR /opt/mysql/run

# House keeping
RUN yum clean all && \
    yum -y update && \
    yum -y install epel-release && \
    yum -y install initscripts \
        htop less file rpmconf git-all bash-completion && rm -rf /var/cache/yum

# C++ development
RUN yum -y install gcc-c++ cmake cmake3 boost-devel xapian-core-devel \
    soci-mysql-devel soci-sqlite3-devel \
    readline-devel sqlite-devel mariadb-devel \
    libicu-devel protobuf-devel protobuf-compiler && rm -rf /var/cache/yum

# Python development
RUN yum -y install python-devel python36-devel && rm -rf /var/cache/yum

# Documentation tools
RUN yum -y install doxygen ghostscript "tex(latex)" && rm -rf /var/cache/yum

#
VOLUME ["/sys/fs/cgroup", "/run", "/tmp"]

# Set up and start Maria (MySQL) database
RUN yum -y install mariadb-server && rm -rf /var/cache/yum
RUN mkdir -p $DB_RUN_DIR && chown -R mysql.mysql $DB_RUN_DIR
RUN mysql_install_db
ADD my.cnf /etc/
RUN chown -R mysql.mysql /var/lib/mysql
WORKDIR /usr
RUN /usr/bin/mysqld_safe --datadir='/var/lib/mysql' --nowatch
#RUN mysqladmin -u root password '$DB_PASS'

# User environment
ADD bashrc $HOME/
RUN cat $HOME/bashrc >> $HOME/.bashrc && rm -f $HOME/bashrc

# Set up of the environment for OpenTREP
RUN mkdir -p $TREP_BASE_DIR
WORKDIR $TREP_BASE_DIR
RUN git clone https://github.com/trep/opentrep.git
WORKDIR $TREP_DIR
RUN mkdir -p build
WORKDIR $TREP_BUILD_DIR

# Launch the build
RUN cmake3 -DCMAKE_INSTALL_PREFIX=${INSTALL_BASEDIR}/opentrep-$TREP_VER \
   -DCMAKE_BUILD_TYPE:STRING=Debug -DINSTALL_DOC:BOOL=OFF \
   -DRUN_GCOV:BOOL=OFF -DLIB_SUFFIX=64 ..
RUN make && make install

# Launch the indexation
RUN ./opentrep/opentrep-indexer --xapiandb $XAPIANDB

# Check that the search works correctly
RUN ./opentrep/opentrep-searcher --xapiandb $XAPIANDB -q nce sfo

#
RUN echo "root:root"|chpasswd
#CMD ["/usr/sbin/init"]
CMD ["/bin/bash"]


