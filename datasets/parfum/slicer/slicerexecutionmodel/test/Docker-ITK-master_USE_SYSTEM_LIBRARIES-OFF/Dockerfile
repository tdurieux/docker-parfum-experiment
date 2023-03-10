FROM dockbuild/centos7
MAINTAINER Insight Software Consortium <community@itk.org>

WORKDIR /usr/src

# February 10, 2022
# - master (d6774dac0) of 2022-02-07 and changes from https://github.com/InsightSoftwareConsortium/ITK/pull/3187
ENV ITK_GIT_COMMIT 060131b628e9a2d3f4613adc077ac04dd1a4ea7b

RUN \
  #
  # Settings
  #
  working_dir=$(pwd) && \
  #
  # Checkout
  #
  git clone git://github.com/jcfr/ITK ITK && \
  cd ITK && git reset --hard ${ITK_GIT_COMMIT} && \
  #
  # Configure
  #
  cd $working_dir && \
  mkdir ITK-build && cd $_ && \
  cmake \
    -G Ninja \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr/local \
    -DBUILD_EXAMPLES:BOOL=OFF \
    -DBUILD_TESTING:BOOL=OFF \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON \
    -DITK_LEGACY_REMOVE:BOOL=ON \
    -DITK_BUILD_DEFAULT_MODULES:BOOL=OFF \
    -DITK_USE_SYSTEM_LIBRARIES:BOOL=OFF \
    -DModule_ITKCommon:BOOL=ON \
    -DModule_ITKIOXML:BOOL=ON \
    -DModule_ITKExpat:BOOL=ON \
    ../ITK && \
  #
  # Build and install
  #
  ninja install && \
  #
  # Cleanup
  #
  rm -rf $working_dir/ITK $working_dir/ITK-build

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG IMAGE
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$IMAGE \
      org.label-schema.description="An open-source CMake-based project that provides macros and associated tools for the easy building of 3D Slicer command line interface (CLI) modules." \
      org.label-schema.url="http://www.slicer.org" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0"
