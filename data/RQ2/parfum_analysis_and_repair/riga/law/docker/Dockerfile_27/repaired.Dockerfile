FROM centos:7

# labels
LABEL law.version="0.1.7"
LABEL law.image_name="riga/law"
LABEL law.image_tag="py27"
LABEL law.image_dir="law-py27"
LABEL law.image_python_major="2"
LABEL law.image_python_minor="7"
LABEL law.image_python_patch="5"
LABEL law.image_python="2.7.5"
LABEL law.image_python_mm="2.7"

# law specific environment variables
ENV LAW_SANDBOX docker::riga/law:py27,docker::riga/law:py2
ENV LAW_IMAGE_NAME law-py27
ENV LAW_IMAGE_TAG py27
ENV LAW_IMAGE_PYTHON_MAJOR 2
ENV LAW_IMAGE_PYTHON_MINOR 7
ENV LAW_IMAGE_PYTHON_PATCH 5
ENV LAW_IMAGE_PYTHON ${LAW_IMAGE_PYTHON_MAJOR}.${LAW_IMAGE_PYTHON_MINOR}.${LAW_IMAGE_PYTHON_PATCH}
ENV LAW_IMAGE_PYTHON_MM ${LAW_IMAGE_PYTHON_MAJOR}.${LAW_IMAGE_PYTHON_MINOR}
ENV LAW_IMAGE_SOURCE_DIR /root/law

# basic environment variables
ENV CPATH /usr/local/include:/usr/include:${CPATH}
ENV LD_LIBRARY_PATH /usr/local/lib:/usr/local/lib64:/usr/lib:/usr/lib64:${LD_LIBRARY_PATH}

# exposed ports
EXPOSE 8082

# bash files
COPY bash_profile /root/.bash_profile
COPY bashrc /root/.bashrc

# installation workdir
WORKDIR /root/install

# prepare yum
RUN yum -y update; yum clean all
RUN yum -y install yum-plugin-priorities yum-utils; rm -rf /var/cache/yum yum clean all
RUN yum -y install epel-release; rm -rf /var/cache/yum yum clean all

# update locales
RUN sed -i -r 's/^(override_install_langs=.+)/#\1/' /etc/yum.conf
RUN yum -y reinstall glibc-common

# basic software
RUN yum -y groupinstall development; yum clean all
RUN yum -y install gcc gcc-c++ libffi-devel openssl-devel glib2-devel libattr-devel openldap-devel \
    zlib-devel bzip2 bzip2-devel json-c-devel ncurses-devel curl-devel readline-devel tk-devel \
    sqlite sqlite-devel libsqlite3x-devel which wget nano screen git git-lfs cmake cmake3; rm -rf /var/cache/yum \
    yum clean all
RUN cd /usr/bin; curl -f https://getmic.ro | bash

# python software
RUN yum -y install python-devel python-setuptools python-docutils; rm -rf /var/cache/yum yum clean all

# WLCG software
RUN rpm -Uvh https://repo.opensciencegrid.org/osg/3.6/osg-3.6-el7-release-latest.rpm
RUN yum-config-manager --add-repo http://linuxsoft.cern.ch/cern/centos/7/cern/x86_64
RUN yum -y update; yum clean all
RUN yum -y install CERN-CA-certs osg-ca-certs osg-voms voms-clients; rm -rf /var/cache/yum yum clean all

# gfal2
ENV GFAL_PLUGIN_DIR /usr/lib64/gfal2-plugins
RUN yum -y install gfal2-all gfal2-devel gfal2-util gfal2-python; rm -rf /var/cache/yum yum clean all
RUN git clone https://github.com/cern-it-sdc-id/gfal2-dropbox.git && \
    cd gfal2-dropbox && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr && \
    make && \
    make install && \
    cd ../.. && \
    rm -rf gfal2-dropbox

# python packages
RUN curl -f https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && \
    python get-pip.py --no-setuptools --no-wheel pip==20.3.4 && \
    rm -f get-pip.py
RUN pip install --no-cache-dir --upgrade setuptools
RUN pip install --no-cache-dir readline
RUN pip install --no-cache-dir slackclient
RUN pip install --no-cache-dir python-telegram-bot
RUN pip install --no-cache-dir flake8

# cleanup installation workdir
WORKDIR /root
RUN rm -rf install

# install law master
RUN git clone https://github.com/riga/law "${LAW_IMAGE_SOURCE_DIR}" && \
    cd "${LAW_IMAGE_SOURCE_DIR}" && \
    pip install --no-cache-dir .
WORKDIR ${LAW_IMAGE_SOURCE_DIR}

# shell initialization
RUN echo 'source "$( law completion )" ""' >> /root/.bash_profile

# init command
CMD bash --login
