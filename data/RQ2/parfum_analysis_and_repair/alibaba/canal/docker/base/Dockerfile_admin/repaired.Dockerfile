FROM canal/osbase:v1

MAINTAINER agapple (jianghang115@gmail.com)

RUN \
    groupadd -r mysql && useradd -r -g mysql mysql && \
    yum -y install wget mysql-server --nogpgcheck && \
    yum clean all && \
    true && rm -rf /var/cache/yum

CMD ["/bin/bash"]