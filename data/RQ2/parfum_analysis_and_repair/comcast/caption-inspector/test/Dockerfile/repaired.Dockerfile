FROM python:3.8-rc-buster

ENV FFMPEG_VERSION=4.0.2 LD_LIBRARY_PATH=/usr/local/lib

RUN apt-get update

# build ffmpeg libraries
RUN apt-get install --no-install-recommends -y make curl gcc g++ nasm yasm && \
  apt-get install --no-install-recommends -y opencl-dev vim libass-dev libavformat-dev \
  libavutil-dev libavfilter-dev uuid-dev zlib1g-dev && \
  DIR=$(mktemp -d) && cd ${DIR} && \
  curl -f -s https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | tar zxvf - -C . && \
  cd ffmpeg-${FFMPEG_VERSION} && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-version3 --enable-hardcoded-tables --enable-shared --enable-static \
    --enable-small --enable-libass --enable-postproc --enable-avresample --enable-libfreetype \
    --disable-lzma --enable-opencl --enable-pthreads && \
  make && \
  make install && \
  make distclean && \
  rm -rf ${DIR} && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y git git && apt-get install --no-install-recommends -y make && apt-get install --no-install-recommends -y clang && pip install --no-cache-dir pytest && apt-get install --no-install-recommends -y mediainfo && cp /usr/bin/mediainfo /usr/local/bin/mediainfo && apt-get install --no-install-recommends -y npm && npm i -g xunit-viewer && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# pull and build gpac
RUN git clone https://github.com/Comcast/gpac-caption-extractor.git && \
    cp -r /gpac-caption-extractor/include/gpac /usr/local/include && \
    cd gpac-caption-extractor && make gpac && cp libgpac.so /usr/local/lib


# add directory /app/caption-inspector
WORKDIR /app
RUN mkdir caption-inspector

ENTRYPOINT /usr/bin/make -C /app/caption-inspector/test docker-test
