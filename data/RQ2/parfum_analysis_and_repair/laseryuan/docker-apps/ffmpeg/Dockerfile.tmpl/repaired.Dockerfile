FROM lasery/ffmpeg:build as build

ENV LANG C.UTF-8
ENV LD_LIBRARY_PATH=/usr/local/lib

ENV ffmpeg_version="{{VERSION}}"
RUN curl -f -L https://ffmpeg.org/releases/ffmpeg-${ffmpeg_version}.tar.gz -o /tmp/ffmpeg.tar.gz && \
    tar xvf /tmp/ffmpeg.tar.gz -C /tmp/ && \
    mv /tmp/ffmpeg-${ffmpeg_version} /tmp/ffmpeg && rm /tmp/ffmpeg.tar.gz

WORKDIR /tmp/ffmpeg
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
      {{#ARCH.is_arm}}
      --arch=armel --target-os=linux \
      --enable-mmal \
      --enable-omx \
      --enable-omx-rpi \
      {{/ARCH.is_arm}}
      --enable-libfdk-aac \
      --disable-debug \
      --disable-shared \
      --enable-gpl \
      --enable-nonfree \
      --disable-ffplay \
      --enable-static && \
    make -j4 && \
    make install

# Sanity Test
RUN ffmpeg -version

# Archive all shared libraries for ffmpeg
RUN mkdir -p /usr/local/lib/ffmpeg
RUN ldd `which ffmpeg` | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' /usr/local/lib/ffmpeg/

FROM {{ARCH.images.base}}

ENV LANG C.UTF-8
ENV LD_LIBRARY_PATH=/usr/local/lib

COPY --from=build /usr/local/bin/ffmpeg /usr/local/bin/
COPY --from=build /usr/local/lib/ffmpeg /usr/local/lib/

RUN ldconfig

# Sanity Test
RUN ffmpeg -version
