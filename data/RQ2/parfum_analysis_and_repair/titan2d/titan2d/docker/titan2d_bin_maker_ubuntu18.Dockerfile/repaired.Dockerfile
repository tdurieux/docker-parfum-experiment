FROM ubuntu:18.04

LABEL description="image for titan2d portable binaries making"

# add devtoolset for fresher compilers
#RUN yum install -y centos-release-scl-rh && \
#    yum install -y devtoolset-8
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y vim wget bzip2 rsync time mc \
        autoconf make automake sudo git \
        libssl-dev chrpath \
        libpng-dev patchelf pkg-config && rm -rf /var/lib/apt/lists/*;
# add users
RUN useradd -m -s /bin/bash centos && \
    echo 'centos:centos' |chpasswd && \
    usermod -a -G sudo centos && \
    echo "centos ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY docker/utils/titan2d_bin_maker /usr/local/bin/

WORKDIR /home/centos

RUN su - centos -c "/usr/local/bin/titan2d_bin_maker install_miniconda" &&\
    su - centos -c "/usr/local/bin/titan2d_bin_maker download_dependencies"

RUN su - centos -c "/usr/local/bin/titan2d_bin_maker install_zlib_1_2_9" &&\
    su - centos -c "/usr/local/bin/titan2d_bin_maker install_hdf5" &&\
    su - centos -c "/usr/local/bin/titan2d_bin_maker install_gdal" &&\
    su - centos -c "/usr/local/bin/titan2d_bin_maker install_python2_7_18" &&\
    su - centos -c "/usr/local/bin/titan2d_bin_maker install_pcre" &&\
    su - centos -c "/usr/local/bin/titan2d_bin_maker install_python2_swig"

RUN su - centos -c "/usr/local/bin/titan2d_bin_maker install_python2_cython" &&\
    su - centos -c "/usr/local/bin/titan2d_bin_maker install_python2_setuptools" &&\
    su - centos -c "/usr/local/bin/titan2d_bin_maker install_python2_numpy1_16_6" &&\
    su - centos -c "/usr/local/bin/titan2d_bin_maker install_python2_h5py" &&\
    su - centos -c "/usr/local/bin/titan2d_bin_maker install_jpeg" &&\
    su - centos -c "/usr/local/bin/titan2d_bin_maker install_freetype2"

RUN su - centos -c "/usr/local/bin/titan2d_bin_maker install_pil" &&\
    su - centos -c "/usr/local/bin/titan2d_bin_maker install_libgd" &&\
    su - centos -c "/usr/local/bin/titan2d_bin_maker install_gnuplot" &&\
    su - centos -c "/usr/local/bin/titan2d_bin_maker install_images2gif" &&\
    su - centos -c "/usr/local/bin/titan2d_bin_maker install_java"

RUN su - centos -c "/usr/local/bin/titan2d_bin_maker modify_dependencies_rpath"

# setup entry point
ENTRYPOINT ["/usr/local/bin/titan2d_bin_maker"]
CMD ["bash_user"]