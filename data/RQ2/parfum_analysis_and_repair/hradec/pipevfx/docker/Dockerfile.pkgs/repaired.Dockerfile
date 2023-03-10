# this pipevfx_centos_pkgs image is the main parent image to build pipeVFX
# so we don't have to download packages all the time.

# we can also create new images based on this one to download new packages
# without having to re-download the ones in this image!

ARG BASE_IMAGE
# FROM $BASE_IMAGE
FROM centos:7.6.1810
# FROM hradec/pipevfx_pkgs:centos7_latest

ARG http
ARG https

ENV http_proxy=$http
ENV https_proxy=$https
ENV ftp_proxy=$http

ARG PRE_CMD
ENV _PRE_CMD=$PRE_CMD

ARG POS_CMD
ENV _POS_CMD=$POS_CMD

# install gcc, git, wget, zip and scons so we can run sconstruct
RUN yum groupinstall -y "Development Tools"
RUN yum -y install python2-scons wget git zip zlib-devel openssl-devel && rm -rf /var/cache/yum
RUN yum -y install source-highlight && rm -rf /var/cache/yum

#COPY docker/run.sh /run.sh
COPY pipeline/tools/scripts/pipevfx_docker_init.sh /run.sh

# create the build folder, if one doesn't exist
RUN mkdir -p /atomo/pipeline/build/

# WARNING: if building for the first time, comment this line out!
RUN mkdir -p /atomo/pipeline/build/.download/
COPY --from=hradec/pipevfx_pkgs:centos7_latest /atomo/pipeline/build/.download  /atomo/pipeline/build/.download/

# install scons
RUN yum -y install wget git zip && rm -rf /var/cache/yum
RUN yum -y install python-setuptools && rm -rf /var/cache/yum
RUN curl -f -s https://bootstrap.pypa.io/pip/2.7/get-pip.py > get-pip.py && python2 ./get-pip.py
RUN python2 -m pip install SCons
RUN yum -y install libffi-devel && rm -rf /var/cache/yum

# cleanup download folder
RUN cd /atomo/pipeline/build && \
    if [ -e /atomo/pipeline/build/.download ] ; then \
        ls -1 .download/*{.tar,.zip}* > /tmp/xx ; \
        ls -1 .download/ | grep -v pip | while read p ; do \
            [ "$(egrep $p /tmp/xx)" == "" ] && rm -rf ".download/$p" ; \
            [ -d .download/$p ] && rm -rf ".download/$p" ; \
        done ; \
        rm /tmp/xx ; \
    fi

# this triggers scons to build python from the pre-downloaded packages
ENV DOCKER_PYTHON=/python/

# download packages so the image contain all tarballs.
# RUN yum install -y python2-pip python3-pip
RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf && \
    touch /atomo/.root

ADD pipeline/tools/python /atomo/pipeline/tools/python
ADD pipeline/tools/config /atomo/pipeline/tools/config
COPY pipeline/build/SConstruct /atomo/pipeline/build/SConstruct

# since we're having trouble with a gcc 4.1.2 built in centos
# (link complains about code needing -fPIC, when it was compiled with it!)
# we are adopting this quick and dirty solution, using a pre-compiled binary
# of gcc 4.1.2, done in an arch linux distro!
# this binaries work without issue, not complening about -fPIC.
COPY docker/gcc-bin-4.1.2.tgz       /atomo/pipeline/build/.download/4.1.2.tar.gz
COPY docker/setuptools-33.1.1.zip   /atomo/pipeline/build/.download/setuptools-33.1.1.zip


ENV TERM=xterm
RUN cd /atomo/pipeline/build && if [ "$_PRE_CMD" != "" ] ; then \
        echo "$_PRE_CMD" ; \
        bash -c "$_PRE_CMD" ; \
    fi

COPY .github /.github
# COPY .github /atomo/.github
RUN ls -l /.github/
RUN cd /atomo/pipeline/build && \
    export CACHING=1 && \
    PYTHONPATH=/atomo/pipeline/tools/python \
    STUDIO=atomo \
    scons install -j $(( $(grep MHz /proc/cpuinfo | wc -l) * 2 ))

RUN cd /atomo/pipeline/build && if [ "$_POS_CMD" != "" ] ; then \
        echo "$_POS_CMD" ; \
        bash -c "$_POS_CMD" ; \
    fi

RUN yum clean all
RUN rm -rf /var/cache/yum/*
RUN rm -r \
    /.github \
    /run.sh \
    /atomo/pipeline/tools/python \
    /atomo/pipeline/tools/config \
    /atomo/pipeline/build/SConstruct \
    /atomo/pipeline/build/.build

# cleanup download folder
RUN cd /atomo/pipeline/build && [ -e /atomo/pipeline/build/.download ] && \
    ( ls -1 .download/*{.tar.gz,.tar,.zip,.run,.rpm,.tgz}* > /tmp/xx ; ls -1 .download/ | grep -v pip | \
    while read p ; do \
        [ "$(egrep $p /tmp/xx)" == "" ] && rm -rf ".download/$p" ; \
        [ -d .download/$p ] && rm -rf ".download/$p" ; \
    done ; rm /tmp/xx ) || true

RUN ls -lh /atomo/pipeline/build/.download/pip*/*/ | egrep pipeline.build
RUN ls -lh /atomo/pipeline/build/.download/pip*/*/
RUN ls -lh /atomo/pipeline/build/.download/


RUN touch /atomo/.root


RUN yum -y install \
    libXcursor-devel \
    libXrandr-devel \
    libXinerama-devel \
    libXi-devel \
    mesa-libGLU-devel && rm -rf /var/cache/yum


# RUN ln -s /lib64/libssl.so /lib64/libssl.so.10 && \
#     ln -s /lib64/libcrypto.so /lib64/libcrypto.so.10 && \
#     ln -s /lib64/libtinfo.so.6 /lib64/libtinfo.so.5 && \
#     ln -s /lib64/libnsl.so.2 /lib64/libnsl.so.1

RUN yum clean all
