FROM nvidia/cuda:10.1-cudnn7-devel

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
	python3-opencv ca-certificates python3-dev git wget sudo ninja-build && rm -rf /var/lib/apt/lists/*;
RUN ln -sv /usr/bin/python3 /usr/bin/python

# create a non-root user
ARG USER_ID=1000
RUN useradd -m --no-log-init --system  --uid ${USER_ID} appuser -g sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER appuser
WORKDIR /home/appuser

ENV PATH="/home/appuser/.local/bin:${PATH}"
RUN wget https://bootstrap.pypa.io/get-pip.py && \
	python3 get-pip.py --user && \
	rm get-pip.py

# install dependencies
# See https://pytorch.org/ for other options if you use a different version of CUDA
RUN pip install --no-cache-dir --user tensorboard cmake# cmake from apt-get is too old
RUN pip install --no-cache-dir --user torch==1.6.0+cu101 torchvision==0.7.0+cu101 -f https://download.pytorch.org/whl/cu101/torch_stable.html
RUN pip install --no-cache-dir --user -i https://pypi.tuna.tsinghua.edu.cn/simple tensorboard opencv-python cython yacs termcolor scikit-learn tabulate gdown gpustat faiss-gpu ipdb h5py
