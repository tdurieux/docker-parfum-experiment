ARG BASE_IMAGE=manylinux1_x86_64
FROM quay.io/pypa/$BASE_IMAGE
ENV MAKEFLAGS="-j 16"

# Set up repoforge
COPY RPM-GPG-KEY.dag.txt /tmp/
RUN rpm --import /tmp/RPM-GPG-KEY.dag.txt

#ENV RPMFORGE_FILE "rpmforge-release-0.5.3-1.el5.rf.x86_64.rpm"
#ADD "https://repoforge.cu.be/redhat/el5/en/x86_64/dag/RPMS/${RPMFORGE_FILE}" /tmp/${RPMFORGE_FILE}

#RUN rpm -i /tmp/${RPMFORGE_FILE}

# Install SDL and portmidi dependencies
RUN yum install -y zlib-devel libX11-devel \
    mesa-libGLU-devel audiofile-devel \
    jpackage-utils \
    mikmod-devel giflib-devel dbus-devel \
    dejavu-sans-fonts fontconfig \
    libXcursor-devel libXi-devel libXxf86vm-devel \
    libXrandr-devel libXinerama-devel libXcomposite-devel mesa-libGLU-devel xz && rm -rf /var/cache/yum
RUN yum install -y libcap-devel libxkbcommon-devel && rm -rf /var/cache/yum

ADD brotli /brotli_build/
RUN ["bash", "/brotli_build/build-brotli.sh"]

#ADD bzip2 /bzip2_build/
#RUN ["bash", "/bzip2_build/build-bzip2.sh"]

#ADD zlib-ng /zlib-ng_build/
#RUN ["bash", "/zlib-ng_build/build-zlib-ng.sh"]

ADD libjpegturbo /libjpegturbo_build/
RUN ["bash", "/libjpegturbo_build/build-jpeg-turbo.sh"]

ADD libpng /libpng_build/
RUN ["bash", "/libpng_build/build-png.sh"]

ADD libwebp /webp_build/
RUN ["bash", "/webp_build/build-webp.sh"]

ADD libtiff /libtiff_build/
RUN ["bash", "/libtiff_build/build-tiff.sh"]

ADD opus /opus_build/
RUN ["bash", "/opus_build/build-opus.sh"]

#ADD harfbuzz /harfbuzz_build/
#RUN ["bash", "/harfbuzz_build/build-harfbuzz.sh"]

ADD freetype /freetype_build/
RUN ["bash", "/freetype_build/build-freetype.sh"]

RUN ["rm", "-f", "/lib64/libasound*"]
RUN ["rm", "-f", "/lib/libasound*"]
ADD alsa /alsa_build/
RUN ["bash", "/alsa_build/build-alsa.sh"]

ADD ogg /ogg_build/
RUN ["bash", "/ogg_build/build-ogg.sh"]

ADD mpg123 /mpg123_build/
RUN ["bash", "/mpg123_build/build-mpg123.sh"]

ADD flac /flac_build/
RUN ["bash", "/flac_build/build-flac.sh"]

ADD sndfile /sndfile_build/
RUN ["bash", "/sndfile_build/build-sndfile.sh"]

ADD pulseaudio /pulseaudio_build/
RUN ["bash", "/pulseaudio_build/build-pulseaudio.sh"]

ADD libmodplug /libmodplug_build/
RUN ["bash", "/libmodplug_build/build-libmodplug.sh"]

ADD cmake /cmake_build/
RUN ["bash", "/cmake_build/build-cmake.sh"]

ADD fluidsynth /fluidsynth_build/
RUN ["bash", "/fluidsynth_build/build-fluidsynth.sh"]

ADD sdl_libs /sdl_build/
RUN ["bash", "/sdl_build/build-sdl2-libs.sh"]


ENV MAKEFLAGS=

ADD portmidi /portmidi_build/
RUN ["bash", "/portmidi_build/build-portmidi.sh"]

ENV base_image=$BASE_IMAGE
RUN echo "$base_image"
RUN echo "$BASE_IMAGE"

ADD pypy /pypy_build/
ARG BASE_IMAGE2=manylinux1_x86_64
RUN if [ "$BASE_IMAGE2" = "manylinux2010_x86_64" ] ; then bash /pypy_build/getpypy64.sh ; else echo "no pypy on manylinux1" ; fi
RUN if [ "$BASE_IMAGE2" = "manylinux2014_x86_64" ] ; then bash /pypy_build/getpypy64.sh ; else echo "no pypy on manylinux1" ; fi

