FROM tensorflow/tensorflow:latest-py3

RUN apt-get update && apt-get install --no-install-recommends -y \
  git build-essential wget vim findutils curl \
  pkg-config zip g++ zlib1g-dev unzip python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/bazelbuild/bazel/releases/download/0.28.0/bazel-0.28.0-installer-linux-x86_64.sh
RUN chmod +x bazel-0.28.0-installer-linux-x86_64.sh
RUN bash ./bazel-0.28.0-installer-linux-x86_64.sh

RUN pip3 install --no-cache-dir jupyter matplotlib jupyter_http_over_ws && \
  jupyter serverextension enable --py jupyter_http_over_ws

RUN git clone https://github.com/waymo-research/waymo-open-dataset.git waymo-od
WORKDIR /waymo-od

RUN bash ./configure.sh && \
    bash bazel query ... | xargs bazel build -c opt && \
    bash bazel query 'kind(".*_test rule", ...)' | xargs bazel test -c opt ...

EXPOSE 8888
RUN python3 -m ipykernel.kernelspec

CMD ["bash", "-c", "source /etc/bash.bashrc && bazel run -c opt //tutorial:jupyter_kernel"]
