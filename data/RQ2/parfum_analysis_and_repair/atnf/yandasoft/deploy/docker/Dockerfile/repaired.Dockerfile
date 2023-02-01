FROM ubuntu:bionic as buildenv
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get autoremove -y
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y flex bison && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gfortran && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-filesystem-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-program-options-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-signals-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-system-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-thread-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-regex-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libcppunit-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libcfitsio-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libfftw3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgsl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y liblog4cxx-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libopenblas-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libopenmpi-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpython-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y patch && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y subversion && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y docker && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-numpy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-scipy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wcslib-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxerces-c-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /usr/local/share/casacore
RUN mkdir /usr/local/share/casacore/data
WORKDIR /usr/local/share/casacore/data
RUN wget ftp://ftp.astron.nl/outgoing/Measures/WSRT_Measures.ztar
RUN mv WSRT_Measures.ztar WSRT_Measures.tar.gz
RUN gunzip WSRT_Measures.tar.gz
RUN tar -xvf WSRT_Measures.tar && rm WSRT_Measures.tar
RUN rm WSRT_Measures.tar
RUN mkdir /var/lib/jenkins
RUN mkdir /var/lib/jenkins/workspace
WORKDIR /home
RUN git clone https://ord006@bitbucket.csiro.au/scm/askapsdp/yandasoft.git
WORKDIR /home/yandasoft
WORKDIR /home/yandasoft/deploy/general
RUN ./build_all.sh -C "-DDATA_DIR=/usr/local/share/casacore/data -DCMAKE_BUILD_TYPE=Release"
RUN ./build_all.sh -R "-DCMAKE_BUILD_TYPE=Release"
RUN ./build_all.sh -a -O "-DHAVE_MPI=1 -DCMAKE_BUILD_TYPE=Release"
RUN ./build_all.sh -y -O "-DHAVE_MPI=1 -DCMAKE_BUILD_TYPE=Release"
RUN ./build_all.sh -e -O "-DHAVE_MPI=1 -DCMAKE_BUILD_TYPE=Release"

WORKDIR /

##############################################################
# Create a new image based on only the executable parts of the old image
FROM ubuntu:bionic
# In multistage builds arguments don't copy over
ARG PREFIX=/usr/local
COPY --from=buildenv ${PREFIX} ${PREFIX}
COPY --from=buildenv /home/yandasoft/askap/askap_synthesis.h ${PREFIX}/include/askap









