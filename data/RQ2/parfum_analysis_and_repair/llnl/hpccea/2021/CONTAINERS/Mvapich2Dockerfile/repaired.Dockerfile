FROM centos:8

#install dependencies
RUN dnf install -y make which redhat-rpm-config wget tar bzip2 git
RUN dnf install -y --enablerepo powertools librdmacm libibverbs libibumad numactl-devel libquadmath gcc-gfortran gcc-c++ epel-release libibverbs-devel rdma-core-devel hwloc-libs ibacm-devel libfabric-devel libpsm2-devel

ENV  LD_LIBRARY_PATH=/usr/local/mvapich2-2.3.6/lib:/usr/local/slurm/lib \
     PATH=/usr/local/mvapich2-2.3.6/bin:/usr/share/Modules/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin \
     OMPI_MCA_btl="tcp,self" \
     OMPI_MCA_btl_openib_allow_ib=1 \
     OMPI_MCA_btl_openib_if_include="mlx4_0:1"


#partial slurm installation
RUN wget --no-check-certificate https://github.com/SchedMD/slurm/archive/slurm-20-02-7-1.tar.gz \
  && tar -xf slurm-20-02-7-1.tar.gz \
  && cd slurm-slurm-20-02-7-1 \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/slurm \
  && cd contribs/pmi2 \
  && export LD_LIBRARY_PATH=/usr/local/mvapich2-2.3.6/lib:/usr/local/slurm/lib \
  && export PATH=/usr/local/mvapich2-2.3.6/bin:/usr/share/Modules/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin \
  && export OMPI_MCA_btl="tcp,self" \
  && export OMPI_MCA_btl_openib_allow_ib=1 \
  && export OMPI_MCA_btl_openib_if_include="mlx4_0:1" \
  && make -j32 install \
  && ldconfig && rm slurm-20-02-7-1.tar.gz

WORKDIR /

#for mvapich2
RUN wget https://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.3.6.tar.gz \
    && tar xvf mvapich2-2.3.6.tar.gz && rm mvapich2-2.3.6.tar.gz
WORKDIR mvapich2-2.3.6

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-pm=slurm --with-pmi=pmi2 --prefix=/usr/local/mvapich2-2.3.6 \
    && make -j32 install

WORKDIR /

#for mpiBench
RUN git clone https://github.com/LLNL/mpiBench.git
WORKDIR mpiBench
RUN make

