ARG BASE_IMAGE=ubuntu:18.04
FROM ${BASE_IMAGE} as base

COPY release /opt/release
ADD *.tar.gz /usr/local/

ARG CUDA_VER
ARG CUDA_VERSION
ARG TRT_VERSION
ARG TORCH_VERSION
ARG CUDA_CUDART_VERSION
ARG NVIDIA_CUDA_VERSION
ARG NVIDIA_REQUIRE_CUDA

WORKDIR /root

RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && \
    apt update && apt upgrade -y && \
    apt install --no-install-recommends -y python3.7-dev python3-pip python3-apt python3-setuptools && \
    apt install --no-install-recommends -y dbus systemd systemd-cron iproute2 gnupg2 libfuse2 \
        build-essential bash unzip ffmpeg curl pkg-config ca-certificates libduktape202 \
        libssl1.1 libcpprest libswscale4 libavformat57 graphviz libprotobuf-c1 \
        libopencv-core3.2 libopencv-imgproc3.2 libopencv-imgcodecs3.2 && \
    rm -f /usr/bin/python3 /usr/bin/python && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.7 100 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 100 && \
    update-alternatives --config python3 && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.pip && \
    echo "[global]" > /root/.pip/pip.conf && \
    echo "index-url = https://pypi.python.org/simple" >>/root/.pip/pip.conf && \
    echo "trusted-host = pypi.python.org" >>/root/.pip/pip.conf && \
    echo "timeout = 120" >>/root/.pip/pip.conf && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install --no-cache-dir wheel pyyaml requests opencv-python pillow && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub | apt-key add - && \
    curl -fsSL https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt update && \
    if [ "${CUDA_VERSION}" = "10.2" ];then \
        apt install -y --no-install-recommends \
            libcudnn8=8.0.0.180-1+cuda10.2 \
            libcublas10=10.2.2.89-1; \
    elif [ "${CUDA_VERSION}" = "11.2" ]; then \
        curl -f -LO https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-gpu-linux-x86_64-2.6.0.tar.gz && \
        tar zxf libtensorflow-gpu-linux-x86_64-2.6.0.tar.gz -C /usr/local/ && \
        python3 -m pip install --no-cache-dir tensorflow-gpu==2.6.0 && \
        apt install -y --no-install-recommends \
            libcudnn8=8.1.1.33-1+cuda11.2 \
            libcublas-11-2=11.4.1.1043-1; rm libtensorflow-gpu-linux-x86_64-2.6.0.tar.gz fi && \
    find /usr/local -name "*.a"|xargs rm -f && \
    rm -rf /var/lib/apt/lists/* /root/*

RUN apt update && \
    apt install -y --no-install-recommends \
        cuda-nvtx-${CUDA_VER} \
        cuda-libraries-${CUDA_VER} && \
    ln -s cuda-${CUDA_VERSION} /usr/local/cuda && \
    if [ -n "${TRT_VERSION}" ];then \
        v="7.1.3-1+cuda10.2" && \
        apt install -y --no-install-recommends \
            libcudnn8=8.0.0.180-1+cuda10.2 \
            libnvinfer7=${v} \
            libnvonnxparsers7=${v} \
            libnvparsers7=${v} \
            libnvinfer-plugin7=${v} \
            python3-libnvinfer=${v}; \
    elif [ -n "${TORCH_VERSION}" ]; then \
        curl -f -LO https://download.pytorch.org/libtorch/cu102/libtorch-cxx11-abi-shared-with-deps-1.9.1%2Bcu102.zip && \
        unzip libtorch-*.zip -d /root >/dev/null 2>&1 && \
        cp -af libtorch/* /usr/local/; fi && \
    find /usr/local -name "*.a"|xargs rm -f && \
    rm -rf /var/lib/apt/lists/* /root/*

RUN python3 -m pip install --no-cache-dir /opt/release/python/modelbox-*.whl && \
    dpkg -i /opt/release/*.deb && \
    (cd /lib/systemd/system/sysinit.target.wants/; for i in *; \
    do [ $i = systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    echo "/usr/local/lib" >>  /etc/ld.so.conf && \
    echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    sed -i 's/^SystemMaxUse=.*/SystemMaxUse=16M/g' /etc/systemd/journald.conf && \
    ldconfig -v 2>/dev/null && systemctl enable modelbox

VOLUME ["/sys/fs/cgroup", "/tmp", "/run", "/run/lock"]
STOPSIGNAL SIGRTMIN+3

LABEL com.nvidia.volumes.needed="nvidia_driver" com.nvidia.cuda.verison="${NVIDIA_CUDA_VERSION}"

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin${PATH:+:${PATH}}
ENV LD_LIBRARY_PATH=/usr/local/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES video,compute,utility
ENV NVIDIA_REQUIRE_CUDA "${NVIDIA_REQUIRE_CUDA}"

CMD ["/sbin/init", "--log-target=journal"]
