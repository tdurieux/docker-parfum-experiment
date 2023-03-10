# This file builds the base image for metadata backend server.
# The images are at gcr.io/kubeflow-images-public/metadata-base.

FROM golang:1.12

RUN apt-get update && apt-get -y --no-install-recommends install cmake unzip patch wget && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp && \
    wget -O /tmp/bazel-installer.sh https://github.com/bazelbuild/bazel/releases/download/0.24.1/bazel-0.24.1-installer-linux-x86_64.sh && \
    chmod +x bazel-installer.sh && \
    ./bazel-installer.sh --user

ENV PATH=/root/bin:${PATH}

CMD ["bash"]
