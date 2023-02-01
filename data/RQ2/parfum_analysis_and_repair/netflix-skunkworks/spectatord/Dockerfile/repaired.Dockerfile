FROM BASEOS_IMAGE
MAINTAINER Netflix Observability Engineering

RUN sudo apt update
RUN sudo apt install --no-install-recommends -y curl gnupg software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --batch --dearmor > bazel.gpg
RUN sudo mv bazel.gpg /etc/apt/trusted.gpg.d/
RUN echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
RUN sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN sudo apt update
RUN sudo apt -y --no-install-recommends install bazel binutils-dev g++-10 libiberty-dev && rm -rf /var/lib/apt/lists/*;
