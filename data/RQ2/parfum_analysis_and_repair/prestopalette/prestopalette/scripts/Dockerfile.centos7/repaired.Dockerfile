FROM centos:7

ENV BUILD_HOME=/usr/local/prestopalette/

RUN mkdir -p $BUILD_HOME

# cd $BUILD_HOME
WORKDIR $BUILD_HOME

# cp . $BUILD_HOME
ADD . $BUILD_HOME

# $BUILD_HOME/scripts/setup_centos7.sh
RUN $BUILD_HOME/scripts/setup_centos7.sh

# $BUILD_HOME/scripts/build_fedora.sh
RUN $BUILD_HOME/scripts/build_fedora.sh

# required for Fedora image
CMD ["/bin/bash"]