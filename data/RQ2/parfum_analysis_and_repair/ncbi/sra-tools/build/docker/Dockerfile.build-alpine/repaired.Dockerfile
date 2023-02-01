FROM alpine:latest AS build
RUN apk add --no-cache build-base util-linux linux-headers g++ ninja cmake git libquadmath
RUN ln -fs /usr/lib/libquadmath.so.0.0.0 /usr/lib/libquadmath.so

ARG CMAKE_BUILD_SHARED_LIBS=1
ARG VDB_BRANCH=engineering
ARG SRA_BRANCH=${VDB_BRANCH}
WORKDIR /root
RUN git clone -b ${VDB_BRANCH} --depth 1 https://github.com/ncbi/ncbi-vdb.git
WORKDIR ncbi-vdb
RUN sed -e '/add_subdirectory\s*\(\s*vdb3\s*\)/ d' -i CMakeLists.txt && \
    sed -e '/^#undef memcpy/,/^#endif/ d' -i interfaces/kfc/defs.h && \
    sed -e '/gnu\/libc-version.h/ d' -e '/gnu_get_libc_version/ d' -i libs/kns/manager.c
WORKDIR /root
RUN cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
          -S ncbi-vdb -B build/ncbi-vdb && \
    cmake --build build/ncbi-vdb
RUN git clone -b ${SRA_BRANCH} --depth 1 https://github.com/ncbi/sra-tools.git
WORKDIR sra-tools
RUN sed -e'/execinfo.h/ s/^/\/\//' -e'/backtrace/ s/^/\/\//' -i tools/driver-tool/secure/except.cpp && \
    sed -e'/config->noInstallID/,/^\s*$/ d' -i tools/driver-tool/sratools.cpp
WORKDIR /root
RUN cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
          -DVDB_INCDIR=/root/ncbi-vdb/interfaces \
          -DVDB_LIBDIR=/root/build/ncbi-vdb/lib \
          -S sra-tools -B build/sra-tools && \
    cmake --build build/sra-tools
RUN cmake -P build/sra-tools/cmake_install.cmake
RUN mkdir -p /root/.ncbi
RUN printf '/LIBS/IMAGE_GUID = "%s"\n' `uuidgen` > /root/.ncbi/user-settings.mkfg && \
    printf '/libs/cloud/report_instance_identity = "true"\n' >> /root/.ncbi/user-settings.mkfg

FROM alpine:latest
LABEL author="Kenneth Durbrow" \
      maintainer="kenneth.durbrow@nih.gov" \
      vendor="NCBI/NLM/NIH" \
      url="https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software" \
      vcs-url="https://github.com/ncbi/sra-tools/" \
      description="NCBI SRA Toolkit + a working default configuration." \
      notice="WHEN USING THIS IMAGE IN A CLOUD ENVIRONMENT, YOU WILL BE SENDING YOUR CLOUD INSTANCE IDENTITY TO NCBI."
RUN apk add --no-cache libstdc++ libgcc
COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /root/.ncbi /root/.ncbi
# everyone needs to be able to list and read it
RUN chmod go+rx /root /root/.ncbi && chmod go+r /root/.ncbi/user-settings.mkfg
#  very basic smoke test to check if runnable
RUN touch foo && srapath ./foo >/dev/null 2>/dev/null && rm foo
