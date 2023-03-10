FROM boinc/client:nvidia

LABEL maintainer="BOINC" \
      description="Multi GPU-savvy (Intel 5th gen+ & Nvidia) BOINC client."

# Install
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Generic OpenCL ICD Loader
    ocl-icd-libopencl1 \
# Install Intel NEO OpenCL
    intel-opencl-icd && \
# Cleaning up
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*