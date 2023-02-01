FROM ethcscs/mpich:ub1804_cuda92_mpi314

RUN apt update \
    && apt install --no-install-recommends -y ca-certificates patch && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp \
    && wget https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.6.1.tar.gz \
    && tar xf osu-micro-benchmarks-5.6.1.tar.gz \
    && cd osu-micro-benchmarks-5.6.1 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local CC=$(which mpicc) CFLAGS=-O3 \
    && make -j2 \
    && make install \
    && cd .. \
    && rm -rf osu-micro-benchmarks-5.6.1* && rm osu-micro-benchmarks-5.6.1.tar.gz

WORKDIR /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt
CMD ["mpiexec", "-n", "2", "-bind-to", "core", "./osu_latency"]
