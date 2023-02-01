FROM centos
# FROM centos:7

ADD . /tmp/bj
WORKDIR /tmp/bj

#
# is there a way to pull the source release from github?
#
RUN yum -y install rsync && rm -rf /var/cache/yum
RUN yum -y install gcc && rm -rf /var/cache/yum
RUN yum -y install gcc-gfortran && rm -rf /var/cache/yum
RUN yum -y install gcc-c++ && rm -rf /var/cache/yum
RUN yum -y install make && rm -rf /var/cache/yum
#RUN yum -y install wget
RUN yum -y install expat-devel && rm -rf /var/cache/yum
RUN yum -y install m4 && rm -rf /var/cache/yum
RUN yum -y install jasper-devel && rm -rf /var/cache/yum
RUN yum -y install flex-devel && rm -rf /var/cache/yum
RUN yum -y install zlib-devel && rm -rf /var/cache/yum
RUN yum -y install libpng-devel && rm -rf /var/cache/yum
RUN yum -y install bzip2-devel && rm -rf /var/cache/yum
RUN yum -y install qt5-qtbase-devel && rm -rf /var/cache/yum
RUN yum -y install fftw3-devel && rm -rf /var/cache/yum
RUN yum install -y xorg-x11-server-Xorg xorg-x11-xauth xorg-x11-apps && rm -rf /var/cache/yum

#RUN yum -y install libX11-devel

#RUN  cd /tmp/bj
#
RUN tar xvfz lrose-blaze-20180516.src.tar.gz && rm lrose-blaze-20180516.src.tar.gz# ???
RUN cd lrose-blaze-20180516.src; ./build_src_release.py

# create a user
# RUN useradd -ms /bin/bash lrose
# USER lrose
# WORKDIR /home/lrose

#
# this is critical to X11 forwarding
#
CMD dbus-uuidgen > /etc/machine-id

# use this to test X11 forwarding
#
# CMD xclock&
