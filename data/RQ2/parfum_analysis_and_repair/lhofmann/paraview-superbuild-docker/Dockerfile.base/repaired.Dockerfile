FROM centos:7

RUN yum install -y \
    curl-devel epel-release \
    git-core git-lfs make which \
    zlib-devel libcurl-devel python-devel \
    freeglut-devel glew-devel graphviz-devel libpng-devel \
    libxcb libxcb-devel libXt-devel xcb-util xcb-util-devel \
    libXcursor-devel mesa-libGL-devel mesa-libEGL-devel \
    libxkbcommon-devel libxkbcommon-x11-devel file mesa-dri-drivers autoconf \
    automake libtool chrpath bison flex libXrandr-devel && rm -rf /var/cache/yum


ENV DEVTOOLSET_VERSION=8

RUN yum install -y centos-release-scl yum-utils && rm -rf /var/cache/yum
RUN yum-config-manager --enable centos-sclo-rh-testing
RUN yum install -y devtoolset-${DEVTOOLSET_VERSION}-gcc devtoolset-${DEVTOOLSET_VERSION}-gcc-c++ \
    devtoolset-${DEVTOOLSET_VERSION}-gcc-gfortran && rm -rf /var/cache/yum

RUN yum clean all

RUN useradd -c paraview -d /home/paraview -M paraview \
    && mkdir /home/paraview \
    && chown paraview:paraview /home/paraview
USER paraview

ENV MAKE=/usr/bin/make

COPY scripts/install_cmake.sh /home/paraview/install_cmake.sh
RUN scl enable devtoolset-${DEVTOOLSET_VERSION} -- sh /home/paraview/install_cmake.sh

ENV PATH="/home/paraview/cmake/bin:${PATH}"

ARG superbuild_version="v5.7.0"
ENV superbuild_version=${superbuild_version}
ARG paraview_version="v5.7.0"
ENV paraview_version=${paraview_version}

# use a very long build path, workaround for issue
# https://gitlab.kitware.com/paraview/paraview-superbuild/issues/123
RUN mkdir -p /home/paraview/buildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuild \
    && cd /home/paraview \
    && git clone --recursive --branch "$superbuild_version" --depth 1 https://gitlab.kitware.com/paraview/paraview-superbuild.git

WORKDIR /home/paraview/buildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuild
