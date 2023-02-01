RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    openjdk-8-jdk \
    python3-dev \
    virtualenv \
    swig && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
    gfortran \
    libblas-dev \
    liblapack-dev && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip --no-cache-dir install \
    Pillow \
    keras_preprocessing \
    tb-nightly \
    h5py \
    matplotlib \
    mock \
    'numpy<1.19.0' \
    scipy \
    sklearn \
    pandas \
    portpicker \
    enum34

# Installs bazelisk
RUN mkdir /bazel && \
    curl -fSsL -o /bazel/LICENSE.txt "https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE" && \
    mkdir /bazelisk && \
    curl -fSsL -o /bazelisk/LICENSE.txt "https://raw.githubusercontent.com/bazelbuild/bazelisk/master/LICENSE" && \
    curl -fSsL -o /usr/bin/bazel "https://github.com/bazelbuild/bazelisk/releases/download/v1.11.0/bazelisk-linux-arm64" && \
    chmod +x /usr/bin/bazel
