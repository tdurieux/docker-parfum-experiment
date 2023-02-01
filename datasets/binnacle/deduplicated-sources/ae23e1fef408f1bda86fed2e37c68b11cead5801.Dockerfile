# Parameters related to building rocfft
ARG base_image

FROM ${base_image}
LABEL maintainer="kent.knox@amd"

# Copy the debian package of rocfft into the container from host
COPY *.deb /tmp/

# Install the debian package, and print out contents of expected changed locations
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --allow-unauthenticated -y \
    /tmp/rocfft-*.deb \
  && rm -f /tmp/*.deb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && printf "ls -la /etc/ld.so.conf.d/\n" && ls -la /etc/ld.so.conf.d/ \
  && printf "ls -la /opt/rocm/include\n" && ls -la /opt/rocm/include \
  && printf "ls -la /opt/rocm/lib\n" && ls -la /opt/rocm/lib \
  && printf "ls -la /opt/rocm/lib/cmake\n" && ls -la /opt/rocm/lib/cmake \
  && printf "ls -la /opt/rocm/rocfft/include\n" && ls -la /opt/rocm/rocfft/include \
  && printf "ls -la /opt/rocm/rocfft/lib\n" && ls -la /opt/rocm/rocfft/lib
