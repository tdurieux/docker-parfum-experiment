FROM centos:8
MAINTAINER platoteam

COPY install-dependencies.sh /usr/local/bin/
RUN set -ex && \
    dnf install -y sudo && \
    install-dependencies.sh && \
    dnf clean all -y && \
    dnf autoremove -y

COPY install-gosu.sh /usr/local/bin/
RUN install-gosu.sh

RUN mkdir /data
WORKDIR /data

COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["entrypoint.sh"]
CMD ["/bin/bash"]