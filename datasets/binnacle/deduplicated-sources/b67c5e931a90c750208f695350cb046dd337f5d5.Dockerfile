from palpitate/opencv-image

# Install FFmpeg
run apt-get install -y -q git make nasm pkg-config libx264-dev libxext-dev libxfixes-dev zlib1g-dev
run apt-get install -y -q libtheora-dev libvorbis-dev
add build_ffmpeg.sh /build_ffmpeg.sh
run /bin/sh /build_ffmpeg.sh
run rm -rf /build_ffmpeg.sh

EXPOSE 5000
