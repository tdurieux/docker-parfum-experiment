# Get base from a pytorch image
FROM pytorch/pytorch:1.5.1-cuda10.1-cudnn7-runtime

# Set to install things in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

# Install system wide softwares
RUN apt-get update \
     && apt-get install --no-install-recommends -y \
        libgl1-mesa-glx \
        libx11-xcb1 \
        git \
        gcc \
        mono-mcs \
        cmake \
        libavcodec-extra \
        ffmpeg \
        curl \
     && apt-get clean all \
     && rm -r /var/lib/apt/lists/*

RUN /opt/conda/bin/conda install --yes \
    astropy \
    matplotlib \
    pandas \
    scikit-learn \
    scikit-image

# Install necessary libraries for deepspeech v2
RUN pip install --no-cache-dir torch
RUN pip install --no-cache-dir tensorflow
RUN pip install --no-cache-dir torchaudio==0.5.1

RUN git clone https://github.com/SeanNaren/warp-ctc.git
RUN cd warp-ctc && mkdir build && cd build && cmake .. && make
RUN cd warp-ctc/pytorch_binding && python setup.py install

RUN git clone https://github.com/SeanNaren/deepspeech.pytorch.git
RUN cd deepspeech.pytorch && git checkout V2.1
RUN cd deepspeech.pytorch && pip install --no-cache-dir -r requirements.txt
RUN cd deepspeech.pytorch && pip install --no-cache-dir -e .

RUN pip install --no-cache-dir numba==0.50.0
RUN pip install --no-cache-dir pytest-cov
RUN pip install --no-cache-dir pydub==0.25.1
