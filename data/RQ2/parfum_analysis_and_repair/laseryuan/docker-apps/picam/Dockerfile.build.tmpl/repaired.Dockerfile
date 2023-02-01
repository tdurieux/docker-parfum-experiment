FROM {{IMAGES.BUILD_BASE}}

ENV LANG C.UTF-8
ENV LD_LIBRARY_PATH=/usr/local/lib

# Install build dependency
RUN apt-get update -qy && apt-get install --no-install-recommends -qy \
      build-essential pkg-config fontconfig \
      libfreetype6-dev libfontconfig1-dev \
      libraspberrypi-doc libraspberrypi-dev raspberrypi-kernel-headers \
      libharfbuzz-dev libharfbuzz0b libfontconfig1 \
      libraspberrypi0 `# Solve libbrcmGLESv2.so dependency issue` \
      libomxil-bellagio-dev libasound2-dev libssl-dev `# Solve libasound dependency issue` && rm -rf /var/lib/apt/lists/*;

# Install fdk-aac
ENV FDK_AAC_PACKAGE="http://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.6.tar.gz"
RUN curl -f -L ${FDK_AAC_PACKAGE} -o /tmp/fdk-aac.tar.gz && \
    tar xvf /tmp/fdk-aac.tar.gz -C /tmp/ && \
    mv /tmp/fdk-aac-0.1.6 /tmp/fdk-aac && rm /tmp/fdk-aac.tar.gz

WORKDIR /tmp/fdk-aac
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make -j4 && \
    make install

# Install libilclient
WORKDIR /opt/vc/src/hello_pi/libs/ilclient
RUN make

# Build and install ffmpeg
ENV ffmpeg_version="4.2.2"
RUN curl -f -L https://ffmpeg.org/releases/ffmpeg-${ffmpeg_version}.tar.gz -o /tmp/ffmpeg.tar.gz && \
    tar xvf /tmp/ffmpeg.tar.gz -C /tmp/ && \
    mv /tmp/ffmpeg-${ffmpeg_version} /tmp/ffmpeg && rm /tmp/ffmpeg.tar.gz

WORKDIR /tmp/ffmpeg
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
      --enable-libfdk-aac \
      --disable-debug \
      --disable-shared \
      --disable-ffplay \
      --enable-static && \
    make -j4 && \
    make install

# Sanity Test
RUN ffmpeg -version
