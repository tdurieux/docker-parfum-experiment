FROM nvidia/cuda:11.3.1-runtime-ubuntu20.04

WORKDIR /home/user

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV HAYSTACK_DOCKER_CONTAINER="HAYSTACK_MINIMAL_GPU_CONTAINER"

# Install software dependencies
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        curl \
        git \
        poppler-utils \
        python3-pip \
        python3.8 \
        python3.8-distutils \
        swig \
        tesseract-ocr && \
    # Cleanup apt cache
    rm -rf /var/lib/apt/lists/* && \
    # Install PDF converter
    curl -f -s https://dl.xpdfreader.com/xpdf-tools-linux-4.04.tar.gz \
    | tar -xvzf - -C /usr/local/bin --strip-components=2 xpdf-tools-linux-4.04/bin64/pdftotext

# Copy Haystack package files but not the source code
COPY setup.py setup.cfg pyproject.toml VERSION.txt LICENSE README.md /home/user/

# Install all the dependencies, including ocr component
RUN pip3 install --upgrade --no-cache-dir pip && \
    pip3 install --no-cache-dir .[ocr] && \
    # Install PyTorch with CUDA 11
    pip3 install --no-cache-dir torch==1.10.2+cu113 -f https://download.pytorch.org/whl/torch_stable.html

# Copy Haystack source code
COPY haystack /home/user/haystack/
# Install Haystack
RUN pip3 install --no-cache-dir --no-deps .[ocr] && \
    # Cleanup copied files after installation is completed
    rm -rf /home/user/*
