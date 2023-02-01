FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04

RUN apt-get update && apt-get install --no-install-recommends -y rsync htop git openssh-server python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir http://download.pytorch.org/whl/cu80/torch-0.2.0.post3-cp27-cp27mu-manylinux1_x86_64.whl
RUN pip install --no-cache-dir torchvision cffi tensorboardX

RUN pip install --no-cache-dir tqdm scipy scikit-image colorama==0.3.7
RUN pip install --no-cache-dir setproctitle pytz ipython