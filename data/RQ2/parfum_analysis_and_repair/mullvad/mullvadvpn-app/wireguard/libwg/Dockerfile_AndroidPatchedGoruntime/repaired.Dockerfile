# To build the image:
# docker build . -t quay.io/mullvad/mullvad-android-app-build
# To push the image to Quay.io:
# docker push quay.io/mullvad/mullvad-android-app-build

FROM debian@sha256:75f7d0590b45561bfa443abad0b3e0f86e2811b1fc176f786cd30eb078d1846f

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    curl \
    file \
    gcc \
    git \
    make \
    python \
    unzip && rm -rf /var/lib/apt/lists/*;

# Install Android NDK
RUN cd /tmp && \
    curl -sf -L -o ndk.zip https://dl.google.com/android/repository/android-ndk-r20b-linux-x86_64.zip && \
    echo "8381c440fe61fcbb01e209211ac01b519cd6adf51ab1c2281d5daad6ca4c8c8c  ndk.zip" | sha256sum -c - && \
    mkdir /opt/android && \
    cd /opt/android && \
    unzip -q /tmp/ndk.zip && \
    rm /tmp/ndk.zip


ENV ANDROID_NDK_HOME="/opt/android/android-ndk-r20b"
ENV NDK_TOOLCHAIN_DIR="${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin"

ENV GOLANG_VERSION 1.16
ENV GOLANG_HASH 013a489ebb3e24ef3d915abe5b94c3286c070dfe0818d5bca8108f1d6e8440d2

# Install Go-lang and patch it to use the appropriate monotonic clock
COPY goruntime-boottime-over-monotonic.diff /opt/goruntime-boottime-over-monotonic.diff
RUN cd /tmp && \
    curl -sf -L -o go.tgz https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    echo "${GOLANG_HASH}  go.tgz" | sha256sum -c - && \
    cd /opt && \
    tar -xzf /tmp/go.tgz && \
    rm /tmp/go.tgz && \
    patch -p1 -f -N -r- -d "/opt/go" < /opt/goruntime-boottime-over-monotonic.diff

ENV PATH=${PATH}:/opt/go/bin
ENV GOROOT=/opt/go
ENV GOPATH=/opt/go-path

RUN apt-get remove -y curl && \
    apt-get autoremove -y

ENTRYPOINT []
