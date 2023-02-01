# This file was generated! Edits made directly to this file may be lost.
#
ARG CUDA_VERSION=10.0
ARG CUDA_SHORT_VERSION=${CUDA_VERSION}
ARG CUDA_MAJORMINOR_VERSION=${CUDA_VERSION}
ARG LINUX_VERSION=centos7
FROM nvidia/cuda:${CUDA_VERSION}-devel-${LINUX_VERSION}

ARG CUDA_SHORT_VERSION
ARG CUDA_MAJORMINOR_VERSION

ARG ARROW_CPP_VERSION=0.12.1
ARG CC_VERSION=7
ARG CXX_VERSION=7
ARG CFFI_VERSION=1.11.5
ARG CMAKE_VERSION=3.12.4
ARG CYTHON_VERSION=0.29.*
ARG DASK_VERSION=1.1.1
ARG DISTRIBUTED_VERSION=1.25.3
ARG FAISSGPU_VERSION=1.5.0
ARG HASH_JOIN=ON
ARG IPYTHON_VERSION=7.3*
ARG LIBGCC_NG_VERSION=7.3.0
ARG LIBGFORTRAIN_NG_VERSION=7.3.0
ARG LIBSTDCXX_NG_VERSION=7.3.0
ARG MINICONDA_URL=https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
ARG NUMBA_VERSION=0.41
ARG NUMPY_VERSION=1.16.2
ARG NVIDIA_CONDA_LABEL=nvidia/label/cuda${CUDA_MAJORMINOR_VERSION}
ARG RAPIDSAI_CONDA_LABEL=rapidsai/label/cuda${CUDA_MAJORMINOR_VERSION}
ARG RMM_VERSION=0.7.*
ARG PANDAS_VERSION=0.23.4
ARG PYARROW_VERSION=0.12.1
ARG PYTHON_VERSION=3.6
ARG SCIPY_VERSION=1.2.1
ARG SKLEARN_VERSION=0.20.3
ARG TINI_URL=https://github.com/krallin/tini/releases/download/v0.18.0/tini
ARG NUM_BUILD_CPUS=""
ARG UTILS_DIR=utils
ARG SUPPORT_FILES_DIR=supportfiles
ARG RAPIDS_SRC_DIR=/rapids

# Add /usr/local/cuda/* temporarily to LD_LIBRARY_PATH to support various build steps
# This will need to be removed later since it causes problems with certain runtime libs (numba.cuda)
ENV LD_LIBRARY_PATH_POSTBUILD=$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH_POSTBUILD:/usr/local/cuda/lib64:/usr/local/cuda/lib64/stubs
ENV NUMBAPRO_NVVM=/usr/local/cuda/nvvm/lib64/libnvvm.so
ENV NUMBAPRO_LIBDEVICE=/usr/local/cuda/nvvm/libdevice
ENV PATH=$PATH:/conda/bin
ENV CUDA_VERSION=${CUDA_MAJORMINOR_VERSION}

# devtoolset-7 ENV vars
# devtoolset-7-* packages will need to be seen first, update PATH accordingly
# NOTE: These are commented out since gcc is being built from source
#   If devtoolset-7 is used, uncomment these vars.
# ENV PATH=/opt/rh/devtoolset-7/root/usr/bin:$PATH:/conda/bin
# ENV CC=/opt/rh/devtoolset-7/root/usr/bin/gcc
# ENV CXX=/opt/rh/devtoolset-7/root/usr/bin/g++
# ENV CUDAHOSTCXX=/opt/rh/devtoolset-7/root/usr/bin/g++
RUN mkdir -p ${RAPIDS_SRC_DIR}/tmp
#
# The support dir contains RPMs that enable additional repos needed
# for CentOS (among other things). Copy them to a temp dir and remove
# after installed.
#
COPY ${SUPPORT_FILES_DIR}/*.rpm ${RAPIDS_SRC_DIR}/tmp

RUN yum install -y ${RAPIDS_SRC_DIR}/tmp/*.rpm && \
    yum upgrade -y && \
    yum install -y \
      bzip2 \
      curl \
      git \
      screen \
      vim \
      wget \
      which \
      clang \
      make \
      libnccl-2.4.2-1+cuda${CUDA_MAJORMINOR_VERSION} \
      libnccl-devel-2.4.2-1+cuda${CUDA_MAJORMINOR_VERSION} \
      libnccl-static-2.4.2-1+cuda${CUDA_MAJORMINOR_VERSION} \
      gmp-devel mpfr-devel libmpc-devel file 

RUN curl -L ${TINI_URL} -o /usr/bin/tini && \
    chmod +x /usr/bin/tini

RUN rm -rf ${RAPIDS_SRC_DIR}/tmp
# NOTE: Copying a pre-built gcc7 could be an option to avoid the
# expensive build step.
### COPY gcc7 ${GCC7_DIR}

# Build gcc 7 and set the environment to use it
# NOTE: this step requires packages gmp-devel, mpfr-devel,
# libmpc-devel, and file (see above)

# NOTE: Q: What about devtoolset-7? Will that work instead?
#       A: Not quite:
#          https://stackoverflow.com/questions/49393888/how-can-i-use-the-new-c-11-abi-with-devtoolset-7-on-centos-rhel
#          (tl;dr: devtoolset-7 does not support the new cxx11 ABI since it
#          conflicts with CentOS sys libs.)
#          Rapids will use new new ABI for its binaries, including its own
#          libstdc++, and the rest of CentOS will continue to use the
#          system default libs.

ARG GCC7_DIR=${RAPIDS_SRC_DIR}/gcc7

RUN mkdir -p ${GCC7_DIR}
RUN cd ${GCC7_DIR} && wget -q http://ftp.gnu.org/gnu/gcc/gcc-7.2.0/gcc-7.2.0.tar.gz 
RUN cd ${GCC7_DIR} && tar zxf gcc-7.2.0.tar.gz
RUN cd ${GCC7_DIR}/gcc-7.2.0 && \
    ./configure --prefix=${GCC7_DIR} --disable-multilib && \
    make -j${NUM_BUILD_CPUS} && make install

# Remove gcc source dir and tarfile
RUN rm -r ${GCC7_DIR}/gcc-7.2.0 ${GCC7_DIR}/gcc-7.2.0.tar.gz

# Update environment to use new gcc7
ENV CC=${GCC7_DIR}/bin/gcc
ENV CXX=${GCC7_DIR}/bin/g++
ENV PATH=${GCC7_DIR}/bin:$PATH
ENV CUDAHOSTCXX=${GCC7_DIR}/bin/g++

# Update the current LD_LIBRARY_PATH with the new lib64 dir for
# remaining build steps and LD_LIBRARY_PATH_POSTBUILD for runtime use
# after building the container.
ENV LD_LIBRARY_PATH=${GCC7_DIR}/lib64:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH_POSTBUILD=${GCC7_DIR}/lib64:$LD_LIBRARY_PATH_POSTBUILD

# NOTE: Many/all of the package versions used below are defined in the
# "args" insertfile

# Install conda
## Build combined libgdf/pygdf conda env
RUN curl ${MINICONDA_URL} -o /miniconda.sh && \
    sh /miniconda.sh -b -p /conda && \
    rm -f /miniconda.sh && \
    conda update -y -n base -c conda-forge conda

ADD .condarc-cuda${CUDA_SHORT_VERSION} /conda/.condarc

RUN conda create --no-default-packages -n gdf \
      python=${PYTHON_VERSION} \
      anaconda-client \
      arrow-cpp=${ARROW_CPP_VERSION} \
      cmake=${CMAKE_VERSION} \
      cmake_setuptools \
      conda-build \
      conda-verify \
      cffi=${CFFI_VERSION} \
      cmake=${CMAKE_VERSION} \
      cython=${CYTHON_VERSION} \
      flake8 \
      make \
      numba>=${NUMBA_VERSION} \
      numpy=${NUMPY_VERSION} \
      pandas=${PANDAS_VERSION} \
      pyarrow=${PYARROW_VERSION} \
      pytest \
      pytest-cov \
      scikit-learn=${SKLEARN_VERSION} \
      scipy=${SCIPY_VERSION} \
      conda-forge::blas=1.1=openblas \
      libgcc-ng=${LIBGCC_NG_VERSION} \
      libgfortran-ng=${LIBGFORTRAIN_NG_VERSION} \
      libstdcxx-ng=${LIBSTDCXX_NG_VERSION} \
    && conda clean -a && \
    chmod 777 -R /conda

# Enables "source activate conda"
SHELL ["/bin/bash", "-c"]


# Change LD_LIBRARY_PATH to the _POSTBUILD version (plus CONDA_PREFIX)
# in order to exclude /usr/local/cuda/* since numba.cuda cannot load
# those libs
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH_POSTBUILD:$CONDA_PREFIX


ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
