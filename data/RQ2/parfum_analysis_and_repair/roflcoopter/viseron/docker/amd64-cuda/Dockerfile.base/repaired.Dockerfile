ARG CUDA_VERSION
ARG UBUNTU_VERSION_NUMBER
FROM roflcoopter/viseron-models:latest as models
FROM nvidia/cuda:${CUDA_VERSION}-cudnn8-runtime-ubuntu${UBUNTU_VERSION_NUMBER}

COPY --from=models /detectors/models/darknet /detectors/models/darknet
COPY --from=models /detectors/models/edgetpu /detectors/models/edgetpu

ARG OPENCL_VERSION
ARG GMMLIB_VERSION
ARG IGC_VERSION
ARG LEVEL_ZERO_GPU

ENV \
  LIBVA_DRIVER_NAME=i965 \
  NVIDIA_DRIVER_CAPABILITIES=all \
  NVIDIA_VISIBLE_DEVICES=all

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  wget \
  # VA-API
  vainfo \
  # intel-media-va-driver \
  libva-drm2 \
  libva2 \
  i965-va-driver \
  # OpenCL
  ocl-icd-libopencl1 \
  clinfo \
  # FFmpeg
  libnuma1 && \
  # OpenCL
  mkdir /opencl &&\
  cd /opencl && \
  wget https://github.com/intel/compute-runtime/releases/download/${OPENCL_VERSION}/intel-gmmlib_${GMMLIB_VERSION}_amd64.deb --progress=bar:force:noscroll && \
  wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-${IGC_VERSION}/intel-igc-core_${IGC_VERSION}_amd64.deb --progress=bar:force:noscroll && \
  wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-${IGC_VERSION}/intel-igc-opencl_${IGC_VERSION}_amd64.deb --progress=bar:force:noscroll && \
  wget https://github.com/intel/compute-runtime/releases/download/${OPENCL_VERSION}/intel-opencl_${OPENCL_VERSION}_amd64.deb --progress=bar:force:noscroll && \
  wget https://github.com/intel/compute-runtime/releases/download/${OPENCL_VERSION}/intel-ocloc_${OPENCL_VERSION}_amd64.deb --progress=bar:force:noscroll && \
  wget https://github.com/intel/compute-runtime/releases/download/${OPENCL_VERSION}/intel-level-zero-gpu_${LEVEL_ZERO_GPU}_amd64.deb --progress=bar:force:noscroll && \
  wget https://github.com/intel/compute-runtime/releases/download/${OPENCL_VERSION}/ww15.sum && \
  sha256sum -c ww15.sum && \
  dpkg -i *.deb && \
  rm -R /opencl && \
  # Add NVIDIA to OpenCL runtime
  mkdir -p /etc/OpenCL/vendors && \
  echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd && \
  ln -s /detectors/models/darknet/yolov4.weights /detectors/models/darknet/default.weights && \
  ln -s /detectors/models/darknet/yolov4.cfg /detectors/models/darknet/default.cfg && rm -rf /var/lib/apt/lists/*;
