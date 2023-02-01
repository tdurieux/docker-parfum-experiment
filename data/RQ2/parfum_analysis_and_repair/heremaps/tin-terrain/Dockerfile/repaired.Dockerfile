FROM ubuntu:18.10
RUN apt-get update
RUN apt-get --assume-yes -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get --assume-yes -y --no-install-recommends install gdal-bin libgdal-dev && rm -rf /var/lib/apt/lists/*;
RUN dpkg -l | grep -i gdal
RUN apt-get --assume-yes -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get --assume-yes -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get --assume-yes -y --no-install-recommends install libboost-program-options-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get --assume-yes -y --no-install-recommends install libboost-filesystem-dev && rm -rf /var/lib/apt/lists/*;
ADD . /usr/local/src/tin-terrain/
RUN mkdir /var/tmp/tin-terrain-build/
WORKDIR /var/tmp/tin-terrain-build/
RUN cmake -DCMAKE_BUILD_TYPE=Release /usr/local/src/tin-terrain/
# `nproc` prints the number of available CPU cores
# -jN enables parallel builds with N jobs
# setting the environment variable VERBOSE=1 enables full output of compiler commandlines
RUN VERBOSE=1 make -j`nproc`
RUN cp ./tin-terrain /usr/local/bin/
RUN rm -rf /var/tmp/tin-terrain-build/
WORKDIR /home
