FROM godot-videodecoder-ubuntu-bionic:latest

WORKDIR /opt/godot-videodecoder/ffmpeg-static
COPY ./ffmpeg-static .

ENV OSXCROSS_ROOT=/opt/osxcross
ENV OSXCROSS_BIN_DIR=$OSXCROSS_ROOT/target/bin

# download dependencies
RUN ./build.sh -d -p darwin

ARG JOBS=1
ENV JOBS=$JOBS
ENV THIRDPARTY_DIR=/opt/godot-videodecoder/thirdparty
RUN ./build.sh -B -p darwin -T "$THIRDPARTY_DIR/osx" -j $JOBS

ENV FINAL_TARGET_DIR=/opt/target
ENV PLUGIN_BIN_DIR=/opt/godot-videodecoder/bin

WORKDIR /opt/godot-videodecoder

COPY . .
RUN scons -c platform=osx
RUN scons platform=osx toolchainbin=${OSXCROSS_BIN_DIR} prefix="${FINAL_TARGET_DIR}"