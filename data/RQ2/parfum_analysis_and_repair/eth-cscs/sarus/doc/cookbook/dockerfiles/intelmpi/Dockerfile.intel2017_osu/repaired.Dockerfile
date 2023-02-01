FROM <YOUR-DOCKERHUB-REPO-HERE>/intelmpi:latest

# build and install OSU microbenchmarks
RUN cd /tmp \
    && wget https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.6.1.tar.gz \
    && tar xf osu-micro-benchmarks-5.6.1.tar.gz \
    && cd osu-micro-benchmarks-5.6.1 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local CC=$(which mpiicc) LIBS="/opt/intel/compilers_and_libraries_2017.1.132/linux/compiler/lib/intel64_lin/libirc.a" \
    && make -j2 \
    && make install \
    && cd .. \
    && rm -rf osu-micro-benchmarks-5.6.1* && rm osu-micro-benchmarks-5.6.1.tar.gz

WORKDIR /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt
