FROM godot-videodecoder-ubuntu-bionic:latest

WORKDIR /opt/godot-videodecoder/ffmpeg-static
COPY ./ffmpeg-static .
# download dependencies
RUN ./build.sh -d -p win32

ARG JOBS=1
ENV JOBS=$JOBS
ENV THIRDPARTY_DIR=/opt/godot-videodecoder/thirdparty
RUN ./build.sh -B -p win32 -T "$THIRDPARTY_DIR/win32" -j $JOBS

ENV FINAL_TARGET_DIR=/opt/target
ENV PLUGIN_BIN_DIR=/opt/godot-videodecoder/bin

WORKDIR /opt/godot-videodecoder

COPY . .
RUN scons -c platform=win32
RUN scons platform=win32 prefix="${FINAL_TARGET_DIR}"