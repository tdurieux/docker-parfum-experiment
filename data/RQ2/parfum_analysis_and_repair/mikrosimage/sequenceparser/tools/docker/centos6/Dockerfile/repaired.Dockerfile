FROM centos:6

#Install dependencies
RUN yum install -y wget cmake tar gcc gcc-c++ pcre-devel python-devel && rm -rf /var/cache/yum

#Install boost
RUN wget https://repo.enetres.net/enetres.repo -O /etc/yum.repos.d/enetres.repo && \
    yum install -y boost-devel-1.55.0 && rm -rf /var/cache/yum

#Install JAVA
RUN cd /opt/ && \
    wget -nv --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.rpm && \
    rpm -i jdk-8u111-linux-x64.rpm && \
    rm -rf jdk-8u111-linux-x64.rpm

#Install Swig 2.0.11
RUN cd /opt/ && \
    wget -O swig-2.0.11.tar.gz https://sourceforge.net/projects/swig/files/swig/swig-2.0.11/swig-2.0.11.tar.gz/download && \
    tar xzf swig-2.0.11.tar.gz && \
    cd swig-2.0.11 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && make install && \
    cd /opt/ && rm -rf swig-2.0.11* && rm swig-2.0.11.tar.gz

ENV JAVA_HOME /usr/java/latest
ENV JDK_HOME /usr/java/latest


