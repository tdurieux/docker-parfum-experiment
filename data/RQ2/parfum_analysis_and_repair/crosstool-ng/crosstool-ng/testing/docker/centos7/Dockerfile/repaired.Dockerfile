FROM centos:7
ARG CTNG_UID=1000
ARG CTNG_GID=1000
RUN groupadd -g $CTNG_GID ctng
RUN useradd -d /home/ctng -m -g $CTNG_GID -u $CTNG_UID -s /bin/bash ctng
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y autoconf gperf bison file flex texinfo help2man gcc-c++ libtool make patch \
    ncurses-devel python36-devel perl-Thread-Queue bzip2 git wget which xz unzip rsync && rm -rf /var/cache/yum
RUN ln -sf python36 /usr/bin/python3
RUN wget -O /sbin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64
RUN chmod a+x /sbin/dumb-init
RUN echo 'export PATH=/opt/ctng/bin:$PATH' >> /etc/profile
ENTRYPOINT [ "/sbin/dumb-init", "--" ]
