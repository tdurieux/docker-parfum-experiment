ARG OS_VERSION=27
FROM fedora:${OS_VERSION}

ARG PYTHON_VERSION=3.6

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES=all \
 NVIDIA_DRIVER_CAPABILITIES=compute,utility \
 NVIDIA_REQUIRE_CUDA="cuda>=9.2" \
 PATH="/usr/lib64/ccache:${PATH}"
ADD scripts /tmp/scripts
RUN cd /tmp/scripts && /tmp/scripts/install_fedora_gpu.sh && /tmp/scripts/install_deps.sh -p $PYTHON_VERSION && rm -rf /tmp/scripts