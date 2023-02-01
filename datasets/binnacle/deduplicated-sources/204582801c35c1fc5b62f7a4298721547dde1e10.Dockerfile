FROM laristra/flecsi-third-party:fedora

ARG MPI
ARG COVERAGE
ARG SONARQUBE
ARG SONARQUBE_TOKEN
ARG SONARQUBE_GITHUB_TOKEN
ARG CC
ARG CXX
ARG CXXFLAGS

#for coverage
ARG CI
ARG TRAVIS
ARG TRAVIS_BRANCH
ARG TRAVIS_JOB_NUMBER
ARG TRAVIS_PULL_REQUEST 
ARG TRAVIS_JOB_ID
ARG TRAVIS_TAG
ARG TRAVIS_REPO_SLUG
ARG TRAVIS_COMMIT
ARG TRAVIS_OS_NAME

RUN git clone --recursive https://github.com/laristra/flecsph.git 

RUN rm -rf /home/flecsi/.ccache
USER root
RUN chown -R flecsi:flecsi /home/flecsi/flecsph
RUN yum install -y which; exit 0
USER flecsi

#rebuild flecsi-third-party
WORKDIR /home/flecsi/tpl
RUN git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
RUN git fetch origin FleCSPH
RUN git checkout FleCSPH
RUN git submodule update --recursive
RUN rm -rf build && mkdir build
WORKDIR /home/flecsi/tpl/build
RUN  cmake .. 
USER root
RUN rm -rf /usr/local/include/legion* /usr/local/include/realm*
RUN make VERBOSE=1 -j2
USER flecsi

#build flecsi
WORKDIR /home/flecsi
RUN git clone -b stable/flecsph-compatible --depth 1 --recursive https://github.com/laristra/flecsi flecsi 
RUN  cd flecsi && mkdir build && cd build
WORKDIR flecsi/build
RUN  cmake .. -DFLECSI_RUNTIME_MODEL=legion \
              -DENABLE_LEGION=ON \
              -DENABLE_CLOG=OFF \
              -DENABLE_MPI=ON \
              -DENABLE_OPENMP=ON \
              -DENABLE_MPI_CXX_BINDINGS=ON 
RUN make VERBOSE=1 -j2
USER root
RUN make install
USER flecsi

# build H5hut
WORKDIR /home/flecsi
ENV H5Hut H5hut-1.99.13
RUN wget --no-check-certificate https://amas.psi.ch/H5hut/raw-attachment/wiki/DownloadSources/${H5Hut}.tar.gz
RUN tar -xzf ${H5Hut}.tar.gz
RUN wget -O- https://raw.githubusercontent.com/gentoo/gentoo/e8827415e767b1252f3851edef8e000980b7f2a1/sci-libs/h5hut/files/h5hut-1.99.13-autotools.patch | patch -p0
WORKDIR ${H5Hut}
RUN sed -i 's/H5Pset_fapl_mpiposix (fapl_id, comm, use_gpfs)/H5Pset_fapl_mpio (fapl_id, comm, \&use_gpfs)/g' src/h5core/h5_hdf5_private.h
RUN autoreconf -i -f
#ubuntu needs CC=h5pcc amd HDF5_USE_SHLIB=yes is needed for shared lib
RUN ./configure --disable-static --enable-shared --enable-parallel --prefix=/usr/local CC=h5pcc && HDF5_USE_SHLIB=yes make
USER root
RUN make install
USER flecsi
RUN ldd /usr/local/lib/libH5hut.so

WORKDIR /home/flecsi/flecsph
RUN mkdir build

WORKDIR build
RUN ccache -z
RUN cmake -DENABLE_MPI=ON \
          -DENABLE_UNIT_TESTS=ON \
          -DENABLE_OPENMP=ON \
          -DENABLE_LEGION=ON \
          -DENABLE_DOXYGEN=ON \
          -DENABLE_COVERAGE_BUILD=ON \
          -DCMAKE_CXX_FLAGS="-fpermissive" ..

RUN HDF5_USE_SHLIB=yes make VERBOSE=1 -j2
RUN ccache -s
RUN make doxygen
RUN make install DESTDIR=${PWD}/install && rm -rf ${PWD}/install
RUN make test ARGS="-V" || true
RUN cd .. && $HOME/.local/bin/codecov -F "${CC}"
USER root
RUN make install
USER flecsi
WORKDIR /home/flecsi
