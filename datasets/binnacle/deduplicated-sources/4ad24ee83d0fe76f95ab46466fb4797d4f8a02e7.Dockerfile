# Parameters related to building hipblas
ARG base_image

FROM ${base_image}
LABEL maintainer="kent.knox@amd"

# Copy the rpm package of hipblas into the container from host
COPY *.rpm /tmp/

# Install the rpm package, and print out contents of expected changed locations
# repo.radeon.com does not have rocblas rpm's, so we temporarily install a local copy
#        /tmp/hipblas-*.rpm \
RUN dnf -y update && dnf install -y \
        /tmp/*.rpm \
    && dnf -y clean all \
    && printf "ls -la /etc/ld.so.conf.d/\n" && ls -la /etc/ld.so.conf.d/ \
    && printf "ls -la /opt/rocm/include\n" && ls -la /opt/rocm/include \
    && printf "ls -la /opt/rocm/lib64\n" && ls -la /opt/rocm/lib64 \
    && printf "ls -la /opt/rocm/lib64/cmake\n" && ls -la /opt/rocm/lib64/cmake \
    && printf "ls -la /opt/rocm/hipblas/include\n" && ls -la /opt/rocm/hipblas/include \
    && printf "ls -la /opt/rocm/hipblas/lib64\n" && ls -la /opt/rocm/hipblas/lib64
