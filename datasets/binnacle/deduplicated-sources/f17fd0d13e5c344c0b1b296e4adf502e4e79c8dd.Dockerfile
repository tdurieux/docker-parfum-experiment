FROM ubuntu:14.04

MAINTAINER Craig Citro <craigcitro@google.com>

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y \
        curl \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python-numpy \
        python-pip \
        python-scipy \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install \
        jupyter \
        matplotlib

# Install TensorFlow CPU version.
RUN pip install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.5.0-cp27-none-linux_x86_64.whl

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py && \
    pip --no-cache-dir install requests[security]

RUN pip --no-cache-dir install ipykernel && \
    python -m ipykernel.kernelspec

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

CMD ["/bin/bash"]
