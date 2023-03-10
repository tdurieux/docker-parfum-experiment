FROM ubuntu:16.04

RUN apt -y update
RUN apt -y upgrade
RUN apt -y --no-install-recommends install build-essential g++ git libbz2-dev wget python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install cmake flex bison graphviz graphviz-dev libicu-dev && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install jarwrapper java-common && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp
ENV CM_INSTALLER=cmake-3.10.0-rc3-Linux-x86_64.sh
ENV CM_VER_DIR=/opt/local/cmake-3.10.0
RUN cd /tmp && wget https://cmake.org/files/v3.10/$CM_INSTALLER && chmod a+x $CM_INSTALLER
RUN mkdir -p $CM_VER_DIR
RUN ln -s $CM_VER_DIR /opt/local/cmake
RUN /tmp/$CM_INSTALLER --prefix=$CM_VER_DIR --exclude-subdir
RUN rm -f /tmp/$CM_INSTALLER

RUN cd /tmp && wget https://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.14.src.tar.gz
RUN cd /tmp && tar xvf doxygen-1.8.14.src.tar.gz && rm doxygen-1.8.14.src.tar.gz
RUN mkdir -p /tmp/doxygen-1.8.14/build
RUN cd /tmp/doxygen-1.8.14/build && /opt/local/cmake/bin/cmake -G "Unix Makefiles" ..
RUN cd /tmp/doxygen-1.8.14/build && make -j2
RUN cd /tmp/doxygen-1.8.14/build && make install
RUN rm -f /tmp/doxygen-1.8.14.src.tar.gz
RUN rm -rf /tmp/doxygen-1.8.14

RUN mkdir -p /opt/plantuml
RUN wget -O /opt/plantuml/plantuml.jar https://sourceforge.net/projects/plantuml/files/plantuml.jar/download
ENV DOXYGEN_PLANTUML_JAR_PATH=/opt/plantuml/plantuml.jar

ENV DOXYGEN_OUTPUT_DIRECTORY=html
CMD cd /opt/rippled && doxygen docs/Doxyfile
