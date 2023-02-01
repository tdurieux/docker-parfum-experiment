FROM centos:6.10

# update OS
RUN yum -y update && \
    yum -y install epel-release && \
    yum -y install centos-release-scl && rm -rf /var/cache/yum

# python
RUN yum -y install rh-python36 && rm -rf /var/cache/yum
COPY scripts/python3.6.sh /usr/local/bin/python3.6
COPY scripts/python3.6.sh /usr/local/bin/python3
RUN chmod a+x /usr/local/bin/python3.6 /usr/local/bin/python3
COPY scripts/pip.sh /usr/local/bin/pip
RUN chmod a+x /usr/local/bin/pip
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -U snowflake-connector-python

# aws
RUN pip install --no-cache-dir -U awscli
COPY scripts/aws.sh /usr/local/bin/aws
RUN chmod a+x /usr/local/bin/aws

# install Development tools
RUN yum -y groupinstall "Development Tools" && \
    yum -y install zlib-devel && rm -rf /var/cache/yum

# git
RUN curl -f -o - https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.26.0.tar.gz | tar xfz - && \
    cd git-2.26.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/git && make && make install && \
    ln -s /opt/git/bin/git /usr/local/bin/git

# zstd
RUN yum -y install zstd && rm -rf /var/cache/yum

# jq
RUN yum -y install jq && rm -rf /var/cache/yum

# gosu
RUN curl -f -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64"
RUN chmod +x /usr/local/bin/gosu
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Java
RUN yum -y install java-1.8.0-openjdk-devel && rm -rf /var/cache/yum

# Maven
RUN curl -f -o - https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz | tar xfz - -C /opt && \
    ln -s /opt/apache-maven-3.6.3/bin/mvn /usr/local/bin/mvn

# workspace
RUN mkdir -p /home/user && \
    chmod 777 /home/user
WORKDIR /home/user

COPY pom.xml /root
COPY dependencies /root/dependencies

RUN cd /root && \
    mvn -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn \
        -Dnot-self-contained-jar \
        --batch-mode --fail-never compile && \
    mv $HOME/.m2 /home/user && \
    chmod -R 777 /home/user/.m2

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
