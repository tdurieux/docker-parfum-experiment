FROM godot-videodecoder-ubuntu-xenial:latest

WORKDIR /opt/godot-videodecoder/ffmpeg-static
COPY ./ffmpeg-static .
# download dependencies
RUN ./build.sh -d

ARG JOBS=1
ENV JOBS=$JOBS
ENV THIRDPARTY_DIR=/opt/godot-videodecoder/thirdparty
RUN ./build.sh -B -T "$THIRDPARTY_DIR/x11" -j $JOBS

ENV FINAL_TARGET_DIR=/opt/target
ENV PLUGIN_BIN_DIR=/opt/godot-videodecoder/bin

WORKDIR /opt/godot-videodecoder

COPY . .
RUN scons -c platform=x11
RUN scons platform=x11 prefix="${FINAL_TARGET_DIR}"
RUN ldd /opt/target/x11/libgdnative_videodecoder.so