FROM centos:7

RUN yum install -y gcc \
        gcc-c++ \
        which \
        make \
        wget \
        strace \
        cpio && rm -rf /var/cache/yum

# install Intel compiler + Intel MPI
COPY intel_licence_file.lic /etc/intel_licence_file.lic
COPY intel_installation_config_file /etc/intel_installation_config_file
ADD parallel_studio_xe_2017_update1_cluster_edition_online.tgz .
RUN cd parallel_studio_xe_2017_update1_cluster_edition_online \
    && ./install.sh --ignore-cpu -s /etc/intel_installation_config_file \
    && rm -rf parallel_studio_xe_2017_update1_cluster_edition_online
ENV PATH /opt/intel/compilers_and_libraries_2017/linux/bin/intel64/:$PATH
ENV PATH /opt/intel/compilers_and_libraries_2017/linux/mpi/intel64/bin:$PATH
RUN echo "/opt/intel/compilers_and_libraries_2017/linux/mpi/intel64/lib" > /etc/ld.so.conf.d/intel_mpi.conf \
    && ldconfig
