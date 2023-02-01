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
    h5py \
    matplotlib \
    mock \
    'numpy<1.19.0' \
    scipy \
    sklearn \
    pandas \
    portpicker \
    enum34

# Build and install bazel
ENV BAZEL_VERSION 3.7.2
WORKDIR /
RUN mkdir /bazel && \
    cd /bazel && \
    curl -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-dist.zip && \
    unzip bazel-$BAZEL_VERSION-dist.zip && \
    bash ./compile.sh && \
    cp output/bazel /usr/local/bin/ && \
    rm -rf /bazel && \
    cd -
