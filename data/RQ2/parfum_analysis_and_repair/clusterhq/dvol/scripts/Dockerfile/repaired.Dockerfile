FROM ubuntu
RUN mkdir /target
RUN mkdir -p coreutils-source
RUN cd coreutils-source
RUN apt-get -y update && apt-get -y --no-install-recommends install dpkg-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y source coreutils
RUN cd coreutils-* && \
    FORCE_UNSAFE_CONFIGURE=1 ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN cp /usr/lib/gcc/x86_64-linux-gnu/4.8/crtbeginS.o /usr/lib/gcc/x86_64-linux-gnu/4.8/crtbeginT.o
RUN cd coreutils-* && \
    make SHARED=0 CFLAGS='-static -std=gnu99 -static-libgcc -static-libstdc++ -fPIC'
RUN cd coreutils-* && \
    cp src/cp /target/
