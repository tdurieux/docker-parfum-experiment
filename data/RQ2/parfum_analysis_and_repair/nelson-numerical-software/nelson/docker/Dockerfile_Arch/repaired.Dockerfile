#==============================================================================
# Copyright (c) 2016-present Allan CORNET (Nelson)
#==============================================================================
# This file is part of the Nelson.
#=============================================================================
# LICENCE_BLOCK_BEGIN
# SPDX-License-Identifier: LGPL-3.0-or-later
# LICENCE_BLOCK_END
#==============================================================================

FROM archlinux:latest
LABEL maintainer="Allan CORNET nelson.numerical.computation@gmail.com"

ARG BRANCH_NAME
RUN echo "Nelson's branch: ${BRANCH_NAME}"

RUN pacman -Syu --noconfirm
RUN pacman -S base-devel --noconfirm
RUN pacman -S inetutils --noconfirm
RUN pacman -S gawk --noconfirm
RUN pacman -S m4 --noconfirm
RUN pacman -S pkg-config --noconfirm
RUN pacman -S boost-libs boost --noconfirm
RUN pacman -S cmake --noconfirm
RUN pacman -S libffi --noconfirm
RUN pacman -S icu --noconfirm
RUN pacman -S qt5-base --noconfirm
RUN pacman -S qt5-tools --noconfirm
RUN pacman -S qt5-webkit --noconfirm
RUN pacman -S libxml2 --noconfirm
RUN pacman -S gcc --noconfirm
RUN pacman -S make --noconfirm
RUN pacman -S blas --noconfirm
RUN pacman -S lapack --noconfirm
RUN pacman -S lapacke --noconfirm
RUN pacman -S fftw --noconfirm
RUN pacman -S openmpi --noconfirm
RUN pacman -S hdf5 --noconfirm
RUN pacman -S taglib --noconfirm
RUN pacman -S portaudio --noconfirm
RUN pacman -S libsndfile --noconfirm
RUN pacman -S git --noconfirm
RUN pacman -S zlib --noconfirm
RUN pacman -S curl --noconfirm
RUN pacman -S libgit2 --noconfirm

RUN git clone https://gitlab.com/libeigen/eigen.git /tmp/eigen
RUN mkdir /tmp/eigen-build && cd /tmp/eigen && git checkout 3.4 && cd - && cd /tmp/eigen-build && cmake . /tmp/eigen && make -j4 && make install;       

RUN git clone https://github.com/HDFGroup/hdf5.git /tmp/hdf5-1_12_1
RUN cd /tmp/hdf5-1_12_1 && git checkout hdf5-1_12_1 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --quiet --enable-shared --disable-deprecated-symbols --disable-hl --disable-strict-format-checks --disable-memory-alloc-sanity-check --disable-instrument --disable-parallel --disable-trace --disable-asserts --with-pic --with-default-api-version=v112 CFLAGS="-w" && make install -C src

RUN git clone https://github.com/tbeu/matio /tmp/matio
RUN cd /tmp/matio && git checkout v1.5.21 && cd /tmp/matio && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-shared --enable-mat73=yes --enable-extended-sparse=no --with-pic --with-hdf5=/tmp/hdf5-1_12_1/hdf5 && make && make install;

RUN git clone https://github.com/Nelson-numerical-software/nelson.git
WORKDIR "/nelson"
RUN cd "/nelson" && git checkout ${BRANCH_NAME}

RUN mkdir /home/nelsonuser

RUN groupadd -g 1001 nelsonuser && \
    useradd -r -u 1001 -g nelsonuser nelsonuser

RUN chown -R nelsonuser:nelsonuser /home/nelsonuser

RUN chown -R nelsonuser:nelsonuser /nelson

USER nelsonuser

ENV AUDIODEV null

RUN cmake -DCMAKE_BUILD_TYPE=Release -DWITH_SLICOT=OFF -G "Unix Makefiles" .
RUN cmake --build . -- -j $(nproc)
RUN cmake --build . -- -j $(nproc) get_module_skeleton

RUN cmake --build . -- -j $(nproc) buildhelp
RUN cmake --build . -- -j $(nproc) tests_minimal
RUN cmake --build . -- -j $(nproc) package
RUN cmake --build . -- -j $(nproc) benchs_all_no_display
RUN cmake --build . -- -j $(nproc) tests_all_no_display


ENTRYPOINT ["/nelson/bin/linux/nelson-cli"]
