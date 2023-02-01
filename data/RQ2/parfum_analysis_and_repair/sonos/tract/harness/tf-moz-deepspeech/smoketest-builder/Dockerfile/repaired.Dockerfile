FROM ubuntu:bionic

ENV BAZEL_VERSION 0.22.0

# https://github.com/mozilla/DeepSpeech/tree/master/native_client

RUN apt-get update && apt -y upgrade
RUN apt-get install --no-install-recommends -y libsox-dev && rm -rf /var/lib/apt/lists/*;

# https://docs.bazel.build/versions/master/install-ubuntu.html
RUN apt-get install --no-install-recommends -y python-dev python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pip six numpy wheel setuptools mock
RUN pip install --no-cache-dir -U keras_applications==1.0.6 --no-deps

RUN pip install --no-cache-dir -U keras_preprocessing==1.0.5 --no-deps

RUN apt-get install --no-install-recommends -y pkg-config zip g++ zlib1g-dev unzip curl wget git && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh
RUN chmod +x bazel-$BAZEL_VERSION-installer-linux-x86_64.sh
RUN ./bazel-$BAZEL_VERSION-installer-linux-x86_64.sh

ENV PS1="\[\e[32m\][\[\e[m\]\[\e[31m\]\u\[\e[m\]\[\e[33m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[32m\]]\[\e[m\]\[\e[32;47m\]\\$\[\e[m\]"
