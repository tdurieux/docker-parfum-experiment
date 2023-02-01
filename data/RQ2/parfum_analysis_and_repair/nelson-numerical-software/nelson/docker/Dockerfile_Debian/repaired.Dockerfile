#==============================================================================
# Copyright (c) 2016-present Allan CORNET (Nelson)
#==============================================================================
# This file is part of the Nelson.
#=============================================================================
# LICENCE_BLOCK_BEGIN
# SPDX-License-Identifier: LGPL-3.0-or-later
# LICENCE_BLOCK_END
#==============================================================================

FROM debian:bullseye-slim
LABEL maintainer="Allan CORNET nelson.numerical.computation@gmail.com"

ARG BRANCH_NAME
RUN echo "Nelson's branch: ${BRANCH_NAME}"


RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y autotools-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libtool; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y automake; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y xvfb; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-all-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libopenmpi-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openmpi-bin; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gettext; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pkg-config; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libffi-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libicu-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxml2-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y liblapack-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y liblapacke-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y fftw3; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y fftw3-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libasound-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y portaudio19-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsndfile1-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libtag1-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y alsa-utils; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libhdf5-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y hdf5-tools; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libmatio-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libslicot0; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zlib1g-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libcurl4-openssl-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgit2-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libeigen3-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qtbase5-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qtdeclarative5-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libqt5webkit5-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qtbase5-private-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qtdeclarative5-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qml-module-qtquick-controls; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qml-module-qtquick-dialogs; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qttools5-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qttools5-dev-tools; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libqt5opengl5-dev; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libqt5help5; rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/Nelson-numerical-software/nelson.git
WORKDIR "/nelson"
RUN cd "/nelson" && git checkout ${BRANCH_NAME}

RUN mkdir /home/nelsonuser

RUN groupadd -g 999 nelsonuser && \
    useradd -r -u 999 -g nelsonuser nelsonuser

RUN chown -R nelsonuser:nelsonuser /home/nelsonuser

RUN chown -R nelsonuser:nelsonuser /nelson

USER nelsonuser

ENV AUDIODEV null

RUN cmake -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" .
RUN cmake --build . -- -j $(nproc)
RUN cmake --build . -- -j $(nproc) get_module_skeleton

RUN cmake --build . -- -j $(nproc) buildhelp
RUN cmake --build . -- -j $(nproc) tests_minimal
RUN cmake --build . -- -j $(nproc) package
RUN cmake --build . -- -j $(nproc) benchs_all_no_display
RUN cmake --build . -- -j $(nproc) tests_all_no_display

ENTRYPOINT ["/nelson/bin/linux/nelson-cli"]
