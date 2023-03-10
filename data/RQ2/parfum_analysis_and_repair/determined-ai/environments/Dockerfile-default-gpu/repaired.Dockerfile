ARG BASE_IMAGE
FROM ${BASE_IMAGE}

COPY dockerfile_scripts /tmp/det_dockerfile_scripts

RUN /tmp/det_dockerfile_scripts/install_google_cloud_sdk.sh

ARG TENSORFLOW_PIP
ARG TORCH_PIP
ARG TORCHVISION_PIP
ARG LIGHTNING_PIP
ARG TORCH_PROFILER_GIT
ARG PIN_PROTOBUF

RUN if [ "$TENSORFLOW_PIP" ]; then python -m pip install $TENSORFLOW_PIP; fi
RUN if [ "$TORCH_PIP" ]; then python -m pip install $TORCH_PIP; fi
RUN if [ "$TORCHVISION_PIP" ]; then python -m pip install $TORCHVISION_PIP; fi
RUN if [ "$LIGHTNING_PIP" ]; then python -m pip install $LIGHTNING_PIP; fi
RUN if [ "$PIN_PROTOBUF" ]; then \
 pip install --no-cache-dir $PIN_PROTOBUF; fi

ARG TF_CUDA_SYM
RUN if [ "$TF_CUDA_SYM" ]; then ln -s /usr/local/cuda/lib64/libcusolver.so.11 /opt/conda/lib/python3.8/site-packages/tensorflow/python/libcusolver.so.10; fi

ARG TORCH_PROFILER_GIT
RUN if [ "$TORCH_PROFILER_GIT" ]; then /tmp/det_dockerfile_scripts/torch-tb-profiler-patch.sh; fi

ARG TORCH_CUDA_ARCH_LIST
ARG APEX_GIT
ARG APEX_PATCH
RUN /tmp/det_dockerfile_scripts/install_apex.sh

ARG DET_BUILD_NCCL=1
RUN if [ -n "${DET_BUILD_NCCL}" ]; then /tmp/det_dockerfile_scripts/build_nccl.sh; fi
ARG HOROVOD_NCCL_LINK=${DET_BUILD_NCCL:+STATIC}
ARG HOROVOD_NCCL_HOME=${DET_BUILD_NCCL:+/tmp/det_nccl/build}

ARG HOROVOD_PIP=horovod
ARG HOROVOD_WITH_TENSORFLOW=1
ARG HOROVOD_WITH_PYTORCH=1
ARG HOROVOD_WITHOUT_MXNET=1
ARG HOROVOD_GPU_OPERATIONS=NCCL
ARG HOROVOD_WITHOUT_MPI=1
RUN pip install --no-cache-dir cmake==3.22.4
RUN ldconfig /usr/local/cuda/targets/x86_64-linux/lib/stubs && \
    pip install --no-cache-dir "$HOROVOD_PIP" && \
    ldconfig

RUN python -m pip install -r /tmp/det_dockerfile_scripts/additional-requirements.txt

ARG DEEPSPEED_PIP
RUN if [ -n "$DEEPSPEED_PIP" ]; then /tmp/det_dockerfile_scripts/install_deepspeed.sh; fi

RUN rm -r /tmp/*
