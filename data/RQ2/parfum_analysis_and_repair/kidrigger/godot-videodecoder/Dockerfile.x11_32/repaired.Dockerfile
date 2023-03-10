FROM godot-videodecoder-ubuntu-xenial:latest
RUN apt update && apt install --no-install-recommends -y libc6-dev-i386 libgl1-mesa-dev:i386 && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/godot-videodecoder/ffmpeg-static
COPY ./ffmpeg-static .
# download dependencies
RUN ./build.sh -d -p x11_32

ARG JOBS=1
ENV JOBS=$JOBS
ENV THIRDPARTY_DIR=/opt/godot-videodecoder/thirdparty
RUN ./build.sh -B -p x11_32 -T "$THIRDPARTY_DIR/x11_32" -j $JOBS

ENV FINAL_TARGET_DIR=/opt/target
ENV PLUGIN_BIN_DIR=/opt/godot-videodecoder/bin

WORKDIR /opt/godot-videodecoder

COPY . .
RUN scons -c platform=x11_32
RUN scons platform=x11_32 prefix="${FINAL_TARGET_DIR}"
RUN ldd /opt/target/x11_32/libgdnative_videodecoder.so
