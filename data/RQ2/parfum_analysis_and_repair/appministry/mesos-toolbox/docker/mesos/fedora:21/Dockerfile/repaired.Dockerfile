FROM fedora:21

RUN yum install -y which tar wget \
    && mkdir -p /tmp/maven && cd /tmp/maven \
    && wget https://mirror.olnevhost.net/pub/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz \
    && tar xvf apache-maven-3.3.9-bin.tar.gz \
    && mv apache-maven-3.3.9 /usr/local/apache-maven \
    && cd / && rm -rf /tmp/maven \
    && ln -sf /usr/local/apache-maven/bin/mvn /usr/bin/mvn \
    && yum groupinstall "Development Tools" "Development Libraries" -y \
    && yum update nss -y \
    && yum install -y python-boto libtool redhat-rpm-config gcc-c++ \
                      java-1.8.0-openjdk-devel cyrus-sasl-md5 \
                      apr-devel subversion-devel ruby-devel \
                      rpm-build \
    && gem install fpm --no-ri --no-rdoc && rm -rf /var/cache/yum

ENV M2_HOME /usr/local/apache-maven
ENV M2 /usr/local/apache-maven/bin
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk