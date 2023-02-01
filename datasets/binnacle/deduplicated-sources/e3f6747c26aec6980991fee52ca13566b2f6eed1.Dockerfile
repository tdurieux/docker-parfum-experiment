
# Build from top directory with:
#   docker build -t test/cld:centos6-oraclejdk -f tests/Dockerfile.centos6.oraclejdk .
FROM  centos:6

# TODO: Combine all yum once I'm no longer testing
RUN   yum install -y wget gcc
RUN   yum install -y gcc++ *gcc-c++*

ENV    M2_HOME /usr/local/apache-maven/apache-maven-3.2.1
ENV    M2      $M2_HOME/bin
ENV    PATH    $M2:$PATH

# Install Oracle JDK 8u31
RUN cd /tmp && \
    mkdir /srv/java && \
    curl -L -O -H "Cookie: oraclelicense=accept-securebackup-cookie" -k "http://download.oracle.com/otn-pub/java/jdk/8u31-b13/jdk-8u31-linux-x64.tar.gz" && \
    tar xf jdk-8u31-linux-x64.tar.gz -C /srv/java && \
    rm -f jdk-8u31-linux-x64.tar.gz && \
    ln -s /srv/java/jdk* /srv/java/jdk && \
    ln -s /srv/java/jdk /srv/java/jvm

# Define commonly used JAVA_HOME variable
# Add /srv/java and jdk on PATH variable
ENV JAVA_HOME=/srv/java/jdk \
    PATH=${PATH}:/srv/java/jdk/bin:/srv/java

# Install Maven2
RUN   mkdir /usr/local/apache-maven && \
      cd /usr/local/apache-maven && \
      wget http://mirror.olnevhost.net/pub/apache/maven/binaries/apache-maven-3.2.1-bin.tar.gz && \
      tar xvf apache-maven-3.2.1-bin.tar.gz && \
      rm apache-maven-3.2.1-bin.tar.gz


# TODO: Combine all yum once I'm no longer testing
RUN   yum groupinstall -y 'Development Tools'

ENV    AUTOCONF_VERSION 2.69
RUN    cd /tmp && \
       wget http://ftp.gnu.org/gnu/autoconf/autoconf-${AUTOCONF_VERSION}.tar.gz && \
       tar xvzf autoconf-${AUTOCONF_VERSION}.tar.gz && \
       cd autoconf-${AUTOCONF_VERSION} && \
       ./configure && \
       make && \
       make install && \
       rm -rf autoconf-${AUTOCONF_VERSION}.tar.gz autoconf-${AUTOCONF_VERSION}

ENV    AUTOMAKE_VERSION 1.15
RUN    cd /tmp && \
       wget http://ftp.gnu.org/gnu/automake/automake-${AUTOMAKE_VERSION}.tar.gz && \
       tar xvzf automake-${AUTOMAKE_VERSION}.tar.gz && \
       cd automake-${AUTOMAKE_VERSION} && \
       ./configure && \
       make && \
       make install && \
       rm -rf automake-${AUTOMAKE_VERSION}.tar.gz automake-${AUTOMAKE_VERSION}

ENV    LIBTOOL_VERSION 2.4
RUN    cd /tmp && \
       wget http://ftp.gnu.org/gnu/libtool/libtool-${LIBTOOL_VERSION}.tar.gz && \
       tar xvzf libtool-${LIBTOOL_VERSION}.tar.gz && \
       cd libtool-${LIBTOOL_VERSION} && \
       ./configure && \
       make && \
       make install && \
       rm -rf libtool-${LIBTOOL_VERSION}.tar.gz libtool-${LIBTOOL_VERSION}

COPY     . /opt/cld
WORKDIR  /opt/cld

# C++ compile, test and install
RUN      cd /opt/cld && \
         aclocal && \
         libtoolize --force && \
         automake --add-missing && \
         autoreconf && \
         ./configure && \
         make clean && \
         make && \
         make check && \
         make install

RUN      echo "/usr/local/lib/cld" >> /etc/ld.so.conf.d/cld.conf && \
         ldconfig

# Java build and test
RUN      cd /opt/cld/ports/java && \
         mvn test
