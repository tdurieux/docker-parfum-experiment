FROM nvcr.io/nvidia/l4t-base:r32.6.1
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y python-pip python-opencv python-matplotlib \
    python-scipy python-h5py python-requests python-psutil git cmake wget unzip \
    python-sklearn python-numpy curl wget python-pil python-skimage \
    zlib1g-dev libjpeg-dev libtiff5-dev && \
    curl -f -O https://bootstrap.pypa.io/pip/2.7/get-pip.py && \
    python get-pip.py && \
    python -m pip install --upgrade "pip < 21.0" && \
    rm get-pip.py && rm -rf /var/lib/apt/lists/*;
RUN cd / && wget https://github.com/lhelontra/tensorflow-on-arm/releases/download/v1.8.0/tensorflow-1.8.0-cp27-none-linux_aarch64.whl
ADD assets/requirements.txt /root/requirements.txt
ADD assets/test.py /test.py

RUN pip install --no-cache-dir --ignore-installed  /tensorflow-1.8.0-cp27-none-linux_aarch64.whl && \
    pip install --no-cache-dir --ignore-installed -r /root/requirements.txt && rm /root/requirements.txt && \
    python /test.py && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /root/.cache/pip/ && rm -rf /*.whl && rm /test.py
