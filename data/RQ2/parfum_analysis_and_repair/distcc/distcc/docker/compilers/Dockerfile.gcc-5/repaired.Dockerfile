FROM distcc/base

LABEL maintainer=""

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc-5 \
                    gcc-multilib \
                    g++-5 \
                    g++-multilib && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50 && \
    update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-5 50 && rm -rf /var/lib/apt/lists/*;
