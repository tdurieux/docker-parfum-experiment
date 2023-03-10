FROM ubuntu:artful

ENV BUILD_HOME=/usr/local/prestopalette/

RUN mkdir -p $BUILD_HOME

# cd $BUILD_HOME
WORKDIR $BUILD_HOME

# cp . $BUILD_HOME
ADD . $BUILD_HOME

# $BUILD_HOME/scripts/setup_ubuntu.sh
RUN $BUILD_HOME/scripts/setup_ubuntu.sh

# $BUILD_HOME/scripts/build_qmake.sh
RUN $BUILD_HOME/scripts/build_qmake.sh