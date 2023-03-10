ARG BASE_IMAGE
FROM ${BASE_IMAGE:-library/ubuntu:19.04}

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    wget \
    ed \
    subversion \
    curl \
    texinfo \
    g++ \
    bison \
    flex \
    cvs \
    yasm \
    automake \
    libtool \
    autoconf \
    gcc \
    cmake \
    git \
    make \
    pkg-config \
    zlib1g-dev \
    mercurial \
    unzip \
    pax \
    nasm \
    meson \
    gperf \
    autogen \
    bzip2 \
    autoconf-archive \
    p7zip-full \
    ragel \
    python3-distutils && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/rdp/ffmpeg-windows-build-helpers.git /ffmpeg-windows-build-helpers

WORKDIR /ffmpeg-windows-build-helpers

ENV OUTPUTDIR=/build

CMD ./cross_compile_ffmpeg.sh --build-ffmpeg-shared=y --build-ffmpeg-static=y --disable-nonfree=n --build-intel-qsv=y --compiler-flavors=win64 --enable-gpl=y --high-bitdepth=n \
  && mkdir -p $OUTPUTDIR/workspace/bin \
  && cp -R -f ./sandbox/win64/ffmpeg_git_with_fdk_aac/ffmpeg.exe $OUTPUTDIR/workspace/bin/ffmpeg \
  && cp -R -f ./sandbox/win64/ffmpeg_git_with_fdk_aac/ffprobe.exe $OUTPUTDIR/workspace/bin/ffprobe \
  && cp -R -f ./sandbox/win64/ffmpeg_git_with_fdk_aac/ffplay.exe $OUTPUTDIR/workspace/bin/ffplay
