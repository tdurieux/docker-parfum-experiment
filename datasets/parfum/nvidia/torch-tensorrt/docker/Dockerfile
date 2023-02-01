ARG BASE=22.04
ARG BASE_IMG=nvcr.io/nvidia/tensorrt:${BASE}-py3
FROM ${BASE_IMG} as base

FROM base as torch-tensorrt-builder-base

# Removing any bazel or torch-tensorrt pre-installed from the base image
RUN rm -rf /opt/pytorch/torch_tensorrt /usr/bin/bazel

ARG ARCH="x86_64"
ARG TARGETARCH="amd64"
ARG BAZEL_VERSION=5.1.1

RUN [[ "$TARGETARCH" == "amd64" ]] && ARCH="x86_64" || ARCH="${TARGETARCH}" \
 && wget -q https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-${ARCH} -O /usr/bin/bazel \
 && chmod a+x /usr/bin/bazel

# Workaround for bazel expecting both static and shared versions, we only use shared libraries inside container
RUN touch /usr/lib/$HOSTTYPE-linux-gnu/libnvinfer_static.a

RUN rm -rf /usr/local/cuda/lib* /usr/local/cuda/include \
  && ln -sf /usr/local/cuda/targets/$HOSTTYPE-linux/lib /usr/local/cuda/lib64 \
  && ln -sf /usr/local/cuda/targets/$HOSTTYPE-linux/include /usr/local/cuda/include

RUN apt-get update && apt-get install -y --no-install-recommends locales ninja-build && rm -rf /var/lib/apt/lists/* && locale-gen en_US.UTF-8

FROM torch-tensorrt-builder-base as torch-tensorrt-builder

# Removing any bazel or torch-tensorrt pre-installed from the base image
RUN rm -rf /opt/pytorch/torch_tensorrt

COPY . /workspace/torch_tensorrt/src
WORKDIR /workspace/torch_tensorrt/src
RUN cp ./docker/WORKSPACE.docker WORKSPACE

# This script builds both libtorchtrt bin/lib/include tarball and the Python wheel, in dist/
RUN ./docker/dist-build.sh

FROM base as torch-tensorrt

# Removing any bazel or torch-tensorrt pre-installed from the base image
RUN rm -rf /opt/pytorch/torch_tensorrt

# copy source repo
COPY . /workspace/torch_tensorrt
COPY --from=torch-tensorrt-builder  /workspace/torch_tensorrt/src/py/dist/ .

RUN pip3 install ipywidgets --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org
RUN jupyter nbextension enable --py widgetsnbextension

RUN pip3 install *.whl && rm -fr /workspace/torch_tensorrt/py/dist/* *.whl

ENV LD_LIBRARY_PATH /usr/local/lib/python3.8/dist-packages/torch/lib:/usr/local/lib/python3.8/dist-packages/torch_tensorrt/lib:${LD_LIBRARY_PATH}
ENV PATH /usr/local/lib/python3.8/dist-packages/torch_tensorrt/bin:${PATH}
#
WORKDIR /workspace
RUN mv /workspace/torch_tensorrt /opt/torch_tensorrt
RUN cp /opt/torch_tensorrt/docker/WORKSPACE.docker /opt/torch_tensorrt/WORKSPACE
RUN mkdir torch_tensorrt
RUN ln -s /opt/torch_tensorrt/notebooks /workspace/torch_tensorrt/notebooks

CMD /bin/bash
