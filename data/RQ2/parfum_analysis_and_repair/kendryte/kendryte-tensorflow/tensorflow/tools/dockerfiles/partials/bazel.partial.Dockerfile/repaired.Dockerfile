RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    openjdk-8-jdk \
    ${PYTHON}-dev \
    swig && rm -rf /var/lib/apt/lists/*;

# Install bazel
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    curl -f https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    apt-get update && \
    apt-get install --no-install-recommends -y bazel && rm -rf /var/lib/apt/lists/*;
