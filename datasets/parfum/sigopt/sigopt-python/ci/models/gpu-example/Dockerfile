FROM nvidia/cuda:11.1.1-cudnn8-runtime
USER root
RUN set -ex \
  ; apt-get update -yqq \
  ; apt-get install -yqq git python3 python3-pip \
  ; rm -rf /var/lib/apt/lists/* \
  ; :
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir tensorflow-gpu==2.4.1 numpy
RUN pip3 install --no-cache-dir sigopt

RUN ln -s /usr/local/cuda/lib64/libcusolver.so.11 /usr/local/cuda/lib64/libcusolver.so.10
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda/lib64

COPY venv_requirements.txt /sigopt/venv_requirements.txt
RUN pip3 install -r /sigopt/venv_requirements.txt

RUN useradd sigopt
USER sigopt
COPY . /sigopt
WORKDIR /sigopt
