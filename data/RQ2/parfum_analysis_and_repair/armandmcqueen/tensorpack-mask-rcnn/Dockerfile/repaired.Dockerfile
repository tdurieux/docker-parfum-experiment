# DockerHub unaltered mirror of AWS Deep Learning Container
FROM armandmcqueen/tensorflow-training:1.13-horovod-gpu-py36-cu100-ubuntu16.04

RUN apt-get install -y --no-install-recommends less && rm -rf /var/lib/apt/lists/*;

# Need to reinstall some libraries the DL container provides due to custom Tensorflow binary
RUN pip uninstall -y tensorflow tensorboard tensorflow-estimator keras h5py horovod numpy

# Download and install custom Tensorflow binary
RUN wget https://github.com/armandmcqueen/tensorpack-mask-rcnn/releases/download/v0.0.0-WIP/tensorflow-1.13.0-cp36-cp36m-linux_x86_64.whl && \
    pip install --no-cache-dir tensorflow-1.13.0-cp36-cp36m-linux_x86_64.whl && \
    pip install --no-cache-dir tensorflow-estimator==1.13.0 && \
    rm tensorflow-1.13.0-cp36-cp36m-linux_x86_64.whl

RUN pip install --no-cache-dir keras h5py

# Install Horovod, temporarily using CUDA stubs
RUN ldconfig /usr/local/cuda-10.0/targets/x86_64-linux/lib/stubs && \
    HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1  pip install --no-cache-dir horovod==0.15.2 && \
    ldconfig


# Install OpenSSH for MPI to communicate between containers
RUN mkdir -p /root/.ssh/ && \
  ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa && \
  cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
  printf "Host *\n  StrictHostKeyChecking no\n" >> /root/.ssh/config


RUN pip install --no-cache-dir Cython
RUN pip install --no-cache-dir ujson opencv-python pycocotools matplotlib
RUN pip install --no-cache-dir --ignore-installed numpy==1.16.2


# TODO: Do I really need this now that we are using the DL container?
ARG CACHEBUST=1
ARG BRANCH_NAME

RUN git clone https://github.com/armandmcqueen/tensorpack-mask-rcnn -b $BRANCH_NAME

RUN chmod -R +w /tensorpack-mask-rcnn
RUN pip install --no-cache-dir --ignore-installed -e /tensorpack-mask-rcnn/
