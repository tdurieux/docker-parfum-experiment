# DockerHub unaltered mirror of AWS Deep Learning Container
FROM 578276202366.dkr.ecr.us-east-1.amazonaws.com/dlami

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
RUN apt-get install -y --no-install-recommends openssh-client openssh-server && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/run/sshd && \
  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

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

RUN pip install --no-cache-dir mpi4py

# For Sagemaker
RUN pip install --no-cache-dir sagemaker-containers
