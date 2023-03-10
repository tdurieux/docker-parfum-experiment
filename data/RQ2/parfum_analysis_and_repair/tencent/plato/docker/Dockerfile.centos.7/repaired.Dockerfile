FROM centos:7
MAINTAINER platoteam

COPY install-dependencies.sh /usr/local/bin/
RUN set -ex && \
    yum install -y sudo && \
    install-dependencies.sh && \
    yum clean all -y && \
    yum autoremove -y && rm -rf /var/cache/yum

COPY install-gosu.sh /usr/local/bin/
RUN install-gosu.sh

RUN mkdir /data
WORKDIR /data

COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["entrypoint.sh"]
CMD ["/bin/bash"]
