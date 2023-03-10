FROM hysds/pge-base:latest

MAINTAINER HySDS Dev Team "hysds-dev@jpl.nasa.gov"
LABEL description="Base L2FP PGE Centos7 image for HySDS"

ARG git_oauth_token

# repo and tag
ENV L2FP_GIT_URL https://${git_oauth_token}@github.jpl.nasa.gov/OCO/RtRetrievalFramework
ENV L2FP_TAG B10.0.00_sdos_testing_1

# Number of simultaneous build jobs for make
ENV BUILD_JOBS 8
ENV ABSCO_DIR /absco
ENV MERRA_DIR /merra
ENV L2_SRC_DIR /root/RtRetrievalFramework
ENV L2_BUILD_DIR /src/build
ENV L2_INSTALL_DIR /rtr_framework/install

user root

RUN set -ex \
 && cd /root \
 && echo "GIT_OAUTH_TOKEN=${git_oauth_token}" > /root/.git_oauth_token \
 && source /root/.git_oauth_token \
 && git clone -b ${L2FP_TAG} --single-branch ${L2FP_GIT_URL} \
 && cd $L2_SRC_DIR \
 && yum install -y time gcc gcc-gfortran gcc-c++ make automake patch zlib-devel \
    bzip2-devel file which ruby ruby-devel rubygems rubygem-rdoc doxygen \
    python-matplotlib python-ply python2-future python-sphinx python34 python34-devel \
    python34-pip python34-numpy python34-nose parallel boost boost-devel \
 && yum clean all \
 && gem install narray \
 && pip3 install --no-cache-dir -U pip \
 && pip3 install --no-cache-dir -U setuptools \
 && pip3 install --no-cache-dir -U matplotlib scipy h5py future ply sphinx \
 && mkdir -p $L2_BUILD_DIR \
 && cd $L2_BUILD_DIR \
 && $L2_SRC_DIR/configure THIRDPARTY=build PYTHON=python3 \
    NOSETESTS=nosetests-3.4 PYTHON_VERSION=3.4 --prefix=$L2_INSTALL_DIR \
    -without-documentation --with-absco=$ABSCO_DIR --with-merra=$MERRA_DIR \
 && make -j $BUILD_JOBS all \
 #&& make -j $BUILD_JOBS long_check \
 && make -j $BUILD_JOBS check \
 #&& make -j $BUILD_JOBS run_tests \
 && make install-strip \
 && cd /root \
 && rm -rf $L2_SRC_DIR $L2_BUILD_DIR && rm -rf /var/cache/yum

# as ops user
USER ops
WORKDIR /home/ops

# disable parallel citation notice
RUN set -ex \
 && echo "will cite" | parallel --bibtex

