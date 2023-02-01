###############################################################################
#
#                     Dockerfile_toulbar2 container
#
#           including toulbar2 and its pytoulbar2 Python API
#
# Desc ------------------------------------------------------------------------
#
# Installation from sources with cmake options -DPYTB2=ON and -DXML=ON
#
# Build -----------------------------------------------------------------------
#
# To build toulbar2-docker image :
#
#   docker build -f Dockerfile_toulbar2 -t toulbar2-docker:latest .
#
# Work inside -----------------------------------------------------------------
#
# Then to work inside toulbar2-docker image, under /WORK
# (as local folder to remaining results) :
#
#   docker run -v $PWD:/WORK -ti toulbar2-docker /bin/bash
#
#   and once inside : source /WORK.sh
#
###############################################################################

FROM debian:buster-slim

RUN apt-get update -yq \
&& apt-get install --no-install-recommends git-core -y \
&& apt-get install --no-install-recommends vim -y \
&& apt-get install --no-install-recommends cmake -y \
&& apt-get install --no-install-recommends g++ -y \
&& apt-get install --no-install-recommends libgmp-dev -y \
&& apt-get install --no-install-recommends libboost-graph-dev -y \
&& apt-get install --no-install-recommends libboost-iostreams-dev -y \
&& apt-get install --no-install-recommends zlib1g-dev -y \
&& apt-get install --no-install-recommends liblzma-dev -y \
&& apt-get install --no-install-recommends libxml2-dev -y \
&& apt-get install --no-install-recommends libopenmpi-dev -y \
&& apt-get install --no-install-recommends libjemalloc-dev -y \
&& apt-get install --no-install-recommends pkg-config -y \
&& apt-get install --no-install-recommends python3 -y \
&& apt-get install --no-install-recommends python3-pip -y \
&& pip3 install --no-cache-dir pybind11 \
&& apt-get clean -y && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/toulbar2/toulbar2.git

RUN cd toulbar2 \
&& mkdir build \
&& cd build \
&& cmake -DPYTB2=ON -DXML=ON .. \
&& make

RUN cp /toulbar2/build/lib/Linux/pytb2.cpython-37m-x86_64-linux-gnu.so /toulbar2/pytoulbar2/pytb2.cpython-37m-x86_64-linux-gnu.so

RUN CMDFILE=/WORK.sh \
&& echo "#!/bin/bash" > $CMDFILE \
&& chmod 755 $CMDFILE \
&& echo "#####################################################" >> $CMDFILE \
&& echo "# Init to work into /WORK folder with (py)toulbar2   " >> $CMDFILE \
&& echo "#####################################################" >> $CMDFILE \
&& echo "PATH=\$PATH:/toulbar2/build/bin/Linux:/toulbar2/src:/WORK" >> $CMDFILE \
&& echo "ln -s /toulbar2/pytoulbar2 /WORK/pytoulbar2"           >> $CMDFILE \
&& echo "cd /WORK"                                              >> $CMDFILE


###############################################################################

