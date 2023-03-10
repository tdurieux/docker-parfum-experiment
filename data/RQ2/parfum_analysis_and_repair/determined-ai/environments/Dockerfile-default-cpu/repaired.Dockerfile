ARG BASE_IMAGE
FROM ${BASE_IMAGE}

COPY dockerfile_scripts /tmp/det_dockerfile_scripts

RUN /tmp/det_dockerfile_scripts/install_google_cloud_sdk.sh

ARG TARGETPLATFORM
ARG TENSORFLOW_PIP
ARG TORCH_PIP
ARG TORCHVISION_PIP
ARG LIGHTNING_PIP
ARG TORCH_PROFILER_GIT
ARG PIN_PROTOBUF
RUN if [ "$TENSORFLOW_PIP" ]; then \
        if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
            TENSORFLOW_AARCH64_PIP=$(printf '%s' "$TENSORFLOW_PIP" | sed 's/cpu/aarch64/') \
            && pip install --no-cache-dir $TENSORFLOW_AARCH64_PIP; \
        else \
            pip install --no-cache-dir $TENSORFLOW_PIP; \
        fi; else \
            pip install --no-cache-dir $TENSORFLOW_PIP; \
        fi \
    fi
RUN if [ "$TORCH_PIP" ]; then \
        if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
            TORCH_AARCH64_PIP=$(printf '%s' "$TORCH_PIP" | sed 's/+cpu//g') \
            && pip install --no-cache-dir $TORCH_AARCH64_PIP; \
        else \
            pip install --no-cache-dir $TORCH_PIP; \
        fi; else \
            pip install --no-cache-dir $TORCH_PIP; \
        fi \
    fi
RUN if [ "$TORCHVISION_PIP" ]; then \
 pip install --no-cache-dir $TORCHVISION_PIP; fi
RUN if [ "$LIGHTNING_PIP" ]; then \
 pip install --no-cache-dir $LIGHTNING_PIP; fi
RUN if [ "$PIN_PROTOBUF" ]; then \
 pip install --no-cache-dir $PIN_PROTOBUF; fi

RUN if [ "$TORCH_PROFILER_GIT" ]; then /tmp/det_dockerfile_scripts/torch-tb-profiler-patch.sh; fi
ARG HOROVOD_PIP=horovod
ARG HOROVOD_WITH_TENSORFLOW=1
ARG HOROVOD_WITH_PYTORCH=1
ARG HOROVOD_WITHOUT_MXNET=1
ARG HOROVOD_WITHOUT_MPI=1
ARG HOROVOD_CPU_OPERATIONS=GLOO
RUN pip install --no-cache-dir cmake==3.22.4
RUN pip install --no-cache-dir "$HOROVOD_PIP"

RUN pip install --no-cache-dir -r /tmp/det_dockerfile_scripts/additional-requirements.txt

RUN rm -r /tmp/*
