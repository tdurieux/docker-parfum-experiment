FROM debian:latest

ENV BUILD_HOME=/usr/local/prestopalette/

RUN mkdir -p $BUILD_HOME

# cd $BUILD_HOME
WORKDIR $BUILD_HOME

# cp . $BUILD_HOME
ADD . $BUILD_HOME

# $BUILD_HOME/scripts/setup_debian.sh
RUN $BUILD_HOME/scripts/setup_debian.sh

# $BUILD_HOME/scripts/build_qmake.sh
#RUN $BUILD_HOME/scripts/build_qmake.sh