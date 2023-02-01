FROM ixsystems/zfs:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
      debhelper-compat \
      dh-python \
      cython3 \
      python3-all-dev \
      python3-setuptools \
      git \
      devscripts && rm -rf /var/lib/apt/lists/*;
