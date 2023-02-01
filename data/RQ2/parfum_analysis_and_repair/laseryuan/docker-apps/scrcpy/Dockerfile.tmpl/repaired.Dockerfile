# https://github.com/Genymobile/scrcpy/blob/master/BUILD.md#simple
# https://github.com/pierlon/scrcpy-docker

FROM {{ARCH.images.base}}

{{#ARCH.is_arm}}
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qy
RUN apt install --no-install-recommends -yq \
  ffmpeg libsdl2-2.0-0 adb wget \
  gcc git pkg-config meson ninja-build \
  libavcodec-dev libavformat-dev libavutil-dev libsdl2-dev \
  libavdevice-dev \
  `` && rm -rf /var/lib/apt/lists/*;

RUN git clone --depth 1 --branch {{IMAGE_VERSION}} https://github.com/Genymobile/scrcpy
WORKDIR /scrcpy

# install require version for meson
RUN apt install -y --no-install-recommends python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir meson

# Build scrcpy
RUN ./install_release.sh

# Create scrcpy user for X11
RUN useradd -m -G video scrcpy

WORKDIR /home/scrcpy

USER scrcpy
{{/ARCH.is_arm}}
