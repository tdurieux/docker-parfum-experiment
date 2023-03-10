FROM freesurfer/freesurfer:7.1.1
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

LABEL authors="Christopher Coogan <c.coogan2201@gmail.com>, Adam Li <ali39@jhu.edu>"

# install dependencies - note freesurefer base image uses centos
RUN yum -y update
RUN yum -y install \
    python \
    python-numpy \
    libeigen3-dev \
    clang \
    zlib1g-dev \
    git g++ \
    ca-certificates \
    libqt5opengl5-dev \
    libqt5svg5-dev \
    libgl1-mesa-dev \
    libfftw3-dev \
    libtiff5-dev \
    libpng-dev \
    eigen3-devel \
    zlib-devel libqt5-devel libgl1-mesa-dev fftw-devel libtiff-devel libpng-devel gcc-c++ \
    unzip libXt libXext ncurses-compat-libs && rm -rf /var/cache/yum

# install Matlab compiler runtime for hippocampal/amygdala and brainstem segementation
# The hippocampal/amygdala and brainstem modules require the (free) Matlab runtime.
# You will need to download the Matlab Compiler Runtime (MCR) for Matlab 2014b.
# To do so, please run the following command (you might need root permissions):
RUN fs_install_mcr R2014b

# install miniconda3
RUN yum -y update \
    && yum -y install curl bzip2 \
    && curl -f -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local/ \
    && rm -rf /tmp/miniconda.sh \
    && conda install -y python=3 \
    && conda update conda \
    && conda clean --all --yes \
    && rpm -e --nodeps curl bzip2 && rm -rf /var/cache/yum

RUN yum clean all

# copy freesurefer license
RUN echo $FREESURFER_HOME
COPY ./freesurferlicense.txt /usr/local/freesurfer/.license

# install mrtrix3 from conda
RUN conda install -c mrtrix3 mrtrix3
RUN mrconvert --version

#RUN yum -y install which
#
## install mrtrix3 from source
#RUN mkdir /mrtrix
#RUN git clone https://github.com/MRtrix3/mrtrix3.git --depth 1 /mrtrix
#WORKDIR /mrtrix
#RUN which g++
#RUN ls /usr/bin/
#ENV CXX=/usr/bin/g++
#ENV EIGEN_CFLAGS="-isystem /usr/include/eigen3"
#RUN ./configure
#RUN ./build
#ENV PATH=/mrtrix/release/bin:/mrtrix/scripts/:$PATH
