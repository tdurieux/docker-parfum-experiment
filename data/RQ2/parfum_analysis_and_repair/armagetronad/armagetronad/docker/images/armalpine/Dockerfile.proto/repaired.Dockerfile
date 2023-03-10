LABEL maintainer="Manuel Moos <z-man@users.sf.net>"

# build dependencies
RUN apk add \
autoconf \
automake \
bison \
boost-dev \
boost-thread \
glew-dev \
freetype-dev \
ftgl-dev \
git \
g++ \
make \
libjpeg \
libpng-dev \
libxml2-dev \
protobuf-dev \
python \
sdl-dev \
sdl_image-dev \
sdl_mixer-dev \
sdl2-dev \
sdl2_image-dev \
sdl2_mixer-dev \
--no-cache

FROM base as zbuild

# further dependencies
WORKDIR /root/
COPY download download
RUN mkdir src

# build zthread
RUN cd src && tar -xzf ../download/ZThread*.tar.gz && rm ../download/ZThread*.tar.gz
RUN cd src/ZThread* && bzcat ../../download/zthread.patch.bz2 | patch -p 1
RUN cd src/ZThread* && CXXFLAGS="-fpermissive -DPTHREAD_MUTEX_RECURSIVE_NP=PTHREAD_MUTEX_RECURSIVE" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --enable-shared=false && make install

# pack up result
From base
COPY --from=zbuild /usr/include/zthread /usr/include/zthread
COPY --from=zbuild /usr/bin/zthread* /usr/bin/
COPY --from=zbuild /usr/lib/libZ* /usr/lib/

RUN adduser docker -D
WORKDIR /home/docker
USER docker

