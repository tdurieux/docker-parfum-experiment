from palpitate/opencv-image

# Install FFmpeg
run apt-get install --no-install-recommends -y -q git make nasm pkg-config libx264-dev libxext-dev libxfixes-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
run apt-get install --no-install-recommends -y -q libtheora-dev libvorbis-dev && rm -rf /var/lib/apt/lists/*;
add build_ffmpeg.sh /build_ffmpeg.sh
run /bin/sh /build_ffmpeg.sh
run rm -rf /build_ffmpeg.sh

EXPOSE 5000
