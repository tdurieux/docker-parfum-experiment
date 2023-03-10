FROM ubuntu:18.04
CMD ["jupyter", "notebook"]
RUN echo "deb http://nl.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse" > /etc/apt/sources.list \
    && echo "deb http://nl.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list \
    && apt-get update && apt-get install --no-install-recommends -y apt-utils debconf-utils && apt-get -y upgrade && apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get install --no-install-recommends -y python2.7 python-dev python-numpy python-scipy python-pip python-nose python-tk python-dbus \
                       build-essential git wget cmake flex bison g++ xvfb libcfitsio-dev libreadline6-dev libncurses5-dev \
                       libhdf5-serial-dev libpython3.6-dev libboost-python-dev libblas-dev liblapacke-dev libfftw3-dev \
                       wcslib-dev libboost-program-options-dev libboost-filesystem-dev \
                       libboost-system-dev libboost-python-dev libboost-thread-dev libboost-regex-dev \
                       libqt4-dev pgplot5 openjdk-8-jre libdbus-1-dev libdbus-c++-dev libxml2-dev libxslt1-dev \
                       libqwt-dev libsqlite3-dev liblog4cxx-dev doxygen swig libgsl-dev curl \
                       libgtkmm-3.0-dev liblua5.3-dev libboost-numpy-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Libgsl from 16.04 is too old for CASA, get the version from 18.04
#RUN for i in libgslcblas0_2.4+dfsg-6_amd64.deb libgsl23_2.4+dfsg-6_amd64.deb libgsl-dev_2.4+dfsg-6_amd64.deb; \
#    do wget http://nl.archive.ubuntu.com/ubuntu/pool/universe/g/gsl/$i; dpkg -i $i; rm $i; done

# Default libxerces in 18.04 is too new for casa code, use older version
RUN wget https://launchpadlibrarian.net/344856440/libxerces-c3.1_3.1.4+debian-2build2_amd64.deb \
    && wget https://launchpadlibrarian.net/344856431/libxerces-c-dev_3.1.4+debian-2build2_amd64.deb \
    && dpkg -i libxerces-c3.1_3.1.4+debian-2build2_amd64.deb \
    && dpkg -i libxerces-c-dev_3.1.4+debian-2build2_amd64.deb

# We need an older version of libeigen3 for libsakura
RUN wget https://launchpadlibrarian.net/165141962/libeigen3-dev_3.2.0-8_all.deb \
    && dpkg -i libeigen3-dev_3.2.0-8_all.deb \
    && rm libeigen3-dev_3.2.0-8_all.deb

# install jupyter
RUN apt-get install --no-install-recommends -y gfortran build-essential python-numpy-dev \
    && pip install --no-cache-dir --upgrade pip \
    && /usr/local/bin/pip install matplotlib notebook widgetsnbextension \
    && /usr/local/bin/pip install pyfits astropy \
    # Enable ipywidgets
    && jupyter nbextension enable --py widgetsnbextension --sys-prefix && rm -rf /var/lib/apt/lists/*;

# Dependencies - RPFITS
RUN wget ftp://ftp.atnf.csiro.au/pub/software/rpfits/rpfits.tar.gz \
    && tar zxvf rpfits.tar.gz \
    && cd rpfits/linux64 \
    && make install \
    && cd ../.. \
    && rm -rf rpfits* && rm rpfits.tar.gz

# Dependencies - LIBSAKURA
RUN git clone https://github.com/aardk/libsakura \
    && cd libsakura \
    && wget https://github.com/google/googletest/archive/release-1.7.0.tar.gz \
    && tar zxvf release-1.7.0.tar.gz \
    && ln -s googletest-release-1.7.0 gtest \
    && mkdir build \
    && cd build \
    # Local compiles:
    # cmake -DSIMD_ARCH=NATIVE ..
    # For distribution purposes:
    && cmake -DSIMD_ARCH=SSE4 .. \
    && make \
    && make apidoc \
    && make install \
    && cd ../.. \
    && rm -rf libsakura && rm release-1.7.0.tar.gz

# casa data needs git lfs support
ENV LFSVERSION=v2.6.1
RUN mkdir -p gitlfs-${LFSVERSION} \
    && cd gitlfs-${LFSVERSION} \
    && wget https://github.com/git-lfs/git-lfs/releases/download/${LFSVERSION}/git-lfs-linux-amd64-${LFSVERSION}.tar.gz \
    && tar zxvf git-lfs-linux-amd64-${LFSVERSION}.tar.gz \
    && ./install.sh \
    && cd .. \
    && rm -rf gitlfs-${LFSVERSION} && rm git-lfs-linux-amd64-${LFSVERSION}.tar.gz

ENV HOST_CPU_CORES=8 \
    CASA_BUILD_TYPE=Release \
    CASA_ARCH=linux64 \
    CASA_BRANCH=release/pipeline/5.6.3 \
    workDir=/usr/local/casa \
    CASAPATH="$workDir $CASA_ARCH"

# ASAP need this patch to compile
COPY asap.patch casacore.patch /root/

# Build casa
RUN git clone -b $CASA_BRANCH https://open-bitbucket.nrao.edu/scm/casa/casa.git $workDir \
    && cd $workDir \
    && git submodule update --init casacore \
    && git clone https://open-bitbucket.nrao.edu/scm/casa/casa-asap.git \
    && git clone --no-checkout https://open-bitbucket.nrao.edu/scm/casa/casa-data.git $workDir/data \
    && cd data \
    && git show HEAD:distro | bash \
    # cleanup git, saves ~600MB
    && rm -rf .git ../git\
    # Build casacore
    && cd $workDir/casacore \
    && patch -p1 < /root/casacore.patch \
    && mkdir $workDir/casacore/build \
    && cd $workDir/casacore/build \
    && cmake .. -DCMAKE_BUILD_TYPE=$CASA_BUILD_TYPE -DCMAKE_INSTALL_PREFIX=$workDir/$CASA_ARCH -DDATA_DIR=$workDir/data -DUSE_THREADS=ON -DCFITSIO_INCLUDE_DIR=/usr/include/cfitsio -DUSE_FFTW3=ON -DCFITSIO_INCLUDE_DIR=/usr/include -DCASA_BUILD=ON -DUSE_HDF5=ON -DBUILD_PYTHON=ON \
    && make -j$HOST_CPU_CORES \
    && make install \
    && cd $workDir \
    && rm -rf casacore \
    # build casa code
    && mkdir $workDir/code/build \
    && cd $workDir/code/build \
    && cmake .. -DCMAKE_BUILD_TYPE=$CASA_BUILD_TYPE -DINTERACTIVE_ITERATION=1 -DCMAKE_INSTALL_PREFIX=$workDir/$CASA_ARCH \
    && make -j$HOST_CPU_CORES \
    && cd $workDir \
    && rm -rf code/build \
    # build gcwrap
    && mkdir $workDir/gcwrap/build \
    && cd $workDir/gcwrap/build \
    && cmake .. -Darch=$CASA_ARCH -DCMAKE_INSTALL_PREFIX=$workDir/$CASA_ARCH -DPYTHON_LIBNAME=2.7 -DCMAKE_BUILD_TYPE=$CASA_BUILD_TYPE -DINTERACTIVE_ITERATION=1 \
    && make -j$HOST_CPU_CORES \
    && cd $workDir \
    && rm -rf gcWrap \ 
    # Build asap
    && cd $workDir/casa-asap \
    && ls -l \
    && patch -p1 < /root/asap.patch \
    && mkdir $workDir/casa-asap/build \
    && cd $workDir/casa-asap/build \
    && cmake .. -Darch=$CASA_ARCH -DCMAKE_INSTALL_PREFIX=$workDir/$CASA_ARCH -DPYTHON_LIBNAME=2.7 -DCMAKE_BUILD_TYPE=$CASA_BUILD_TYPE \
    && make -j$HOST_CPU_CORES \
    && cd $workDir \
    && rm -rf casa-asap \
    && rm -rf code

# Add VLBI scripts
RUN git clone https://github.com/jive-vlbi/casa-vlbi /usr/local/casa-vlbi \
    && cp /usr/local/casa-vlbi/*py /usr/local/bin \
    && cp -r /usr/local/casa-vlbi/casavlbitools $workDir/linux64/lib/python2.7

# Add Wsclean
RUN cd $workDir \
    && git clone https://github.com/lofar-astron/LOFARBeam.git \
    && cd LOFARBeam \
    && git checkout v4.1.1 \
    && mkdir -p build \
    && cd build \
    && cmake -DCASACORE_ROOT_DIR=$workDir/linux64 .. \
    && make -j4 \
    && make install \
    && cd $workDir \
    && rm -rf LOFARBeam \
    && git clone https://git.code.sf.net/p/wsclean/code wsclean-code \
    && cd wsclean-code \
    && git checkout wsclean2.9 \
    && mkdir -p wsclean/build \
    && cd wsclean/build \
    && cmake -DCASACORE_ROOT_DIR=$workDir/linux64 .. \
    && make -j4 \
    && make install \
    && cd $workDir \
    && rm -rf wsclean-code

# Add AOFLAGGER
RUN apt-get install --no-install-recommends -y python3-pip libboost-test-dev \
    && pip3 install --no-cache-dir pytest \
    && git clone https://github.com/pybind/pybind11.git \
    && cd pybind11 \
    && git checkout v2.5.0 \
    && mkdir build \
    && cd build \
    && cmake -DDOWNLOAD_CATCH=1  -DPYBIND11_PYTHON_VERSION=2.7 .. \
    && make -j4 \
    && make install \
    && cd .. \
    && python setup.py install \
    && cd .. \
    && rm -rf pybind11 \
    && git clone https://gitlab.com/aroffringa/aoflagger.git \
    && sed -i 's/PythonLibs 3 REQUIRED/PythonLibs 2 REQUIRED/' aoflagger/CMakeLists.txt \
    && mkdir -p aoflagger/build \
    && cd aoflagger/build \
    && cmake -DCASACORE_ROOT_DIR=$workDir/linux64 .. \
    && make -j4 \
    && make install \
    && cp /usr/local/lib/aoflagger.so /usr/local/lib/python2.7/dist-packages \
    && cd ../.. \
    && rm -rf aoflagger && rm -rf /var/lib/apt/lists/*;

# Install jupyter casa wrapper and copy fixed casa tasked
RUN mkdir -p /usr/local/lib/python2.7/dist-packages
COPY python/start_casa /usr/local/lib/python2.7/dist-packages/start_casa
COPY jupyter /usr/local/share/jupyter
COPY python/casa/TablePlotTkAgg.py python/casa/task_setjy.py $workDir/linux64/lib/python2.7/

# Disable ipv6
#RUN echo "net.ipv6.conf.all.disable_ipv6 = 1\n net.ipv6.conf.default.disable_ipv6 = 1\n net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.d/99-sysctl.conf \
#    && cat /etc/sysctl.d/99-sysctl.conf

RUN groupadd -g 1000  jupyter && useradd -u 1000 -m -g jupyter jupyter
EXPOSE 8888
USER jupyter
WORKDIR /home/jupyter
ENV PYTHONPATH="/usr/local/lib/python2.7/dist-packages:/usr/local/casa/linux64/lib/python2.7" \
    LD_LIBRARY_PATH="/usr/local/casa/linux64/lib" \
    CASAPATH="/usr/local/casa/ linux64" \
    PATH="/usr/local/casa/linux64/bin:$PATH" \
    QT_X11_NO_MITSHM=1
RUN mkdir -p /home/jupyter/.jupyter
COPY --chown=jupyter:jupyter docker/jupyter_notebook_config.py /home/jupyter/.jupyter
COPY --chown=jupyter:jupyter docker/create_font_cache.py /home/jupyter
RUN python create_font_cache.py
