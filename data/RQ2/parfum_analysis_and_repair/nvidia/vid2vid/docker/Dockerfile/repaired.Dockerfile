FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

RUN apt-get update && apt-get install --no-install-recommends -y rsync htop git openssh-server && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install --no-cache-dir --upgrade pip

#Torch and dependencies:
RUN pip install --no-cache-dir http://download.pytorch.org/whl/cu80/torch-0.4.0-cp35-cp35m-linux_x86_64.whl
RUN pip install --no-cache-dir torchvision cffi tensorboardX
RUN pip install --no-cache-dir tqdm scipy scikit-image colorama==0.3.7
RUN pip install --no-cache-dir setproctitle pytz ipython

#vid2vid dependencies
RUN apt-get install --no-install-recommends libglib2.0-0 libsm6 libxrender1 -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir dominate requests opencv-python

#pix2pixHD, required for initializing training
RUN git clone https://github.com/NVIDIA/pix2pixHD /pix2pixHD

#vid2vid install
RUN git clone https://github.com/NVIDIA/vid2vid /vid2vid
WORKDIR /vid2vid
#download flownet2 model dependencies
#WARNING: we had an instance where these scripts needed to be re-run after the docker instance was launched
RUN python scripts/download_flownet2.py
RUN python scripts/download_models_flownet2.py


