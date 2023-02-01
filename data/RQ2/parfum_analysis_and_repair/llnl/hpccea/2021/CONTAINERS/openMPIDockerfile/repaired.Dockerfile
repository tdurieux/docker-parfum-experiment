FROM centos:8

#install dependencies
RUN dnf install -y make which redhat-rpm-config wget tar bzip2 git
RUN dnf install -y --enablerepo powertools librdmacm libibverbs libibumad numactl-devel libquadmath gcc-gfortran gcc-c++ epel-release libibverbs-devel rdma-core-devel hwloc-libs ibacm-devel libfabric-devel libpsm2-devel

#partial slurm installation
RUN wget --no-check-certificate https://github.com/SchedMD/slurm/archive/slurm-20-02-7-1.tar.gz \
      && tar -xf slurm-20-02-7-1.tar.gz \
      && cd slurm-slurm-20-02-7-1 \
      && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local \
      && cd contribs/pmi2 \
      && make -j32 install \
      && ldconfig && rm slurm-20-02-7-1.tar.gz

#for openmpi
RUN wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.1.tar.bz2 \
    && tar xvf openmpi-4.1.1.tar.bz2 && rm openmpi-4.1.1.tar.bz2
WORKDIR openmpi-4.1.1
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-pmix --with-pmi=/usr/local --with-psm2 \
    && make -j32 \
    && make install

WORKDIR /
RUN  export LD_LIBRARY_PATH=/usr/local/openmpi-4.1.1-slurm/lib \
    && export PATH=/usr/local/openmpi-4.1.1-slurm/bin:/usr/share/Modules/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin \
    && export OMPI_MCA_btl="tcp,self" \
    && export OMPI_MCA_btl_openib_allow_ib=1 \
    && export OMPI_MCA_btl_openib_if_include="mlx4_0:1"


ENV  LD_LIBRARY_PATH=/usr/local/openmpi-4.1.1-slurm/lib \
     PATH=/usr/local/openmpi-4.1.1-slurm/bin:/usr/share/Modules/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin \
     OMPI_MCA_btl="tcp,self" \
     OMPI_MCA_btl_openib_allow_ib=1 \
     OMPI_MCA_btl_openib_if_include="mlx4_0:1"


#for mpiBench
RUN git clone https://github.com/LLNL/mpiBench.git
WORKDIR mpiBench
RUN make

