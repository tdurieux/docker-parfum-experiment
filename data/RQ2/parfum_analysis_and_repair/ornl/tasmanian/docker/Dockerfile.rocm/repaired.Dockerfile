FROM rocm/dev-ubuntu-20.04:4.3

ENV TZ=America/New_York
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update && apt install --no-install-recommends -y \
        rocm-libs \
        libopenblas-dev \
        cmake \
        python3 \
        python3-numpy \
        libopenmpi-dev \
        openmpi-bin \
        openssh-client \
        libomp-dev \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*