FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04
RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
ENV  LANG="en_US.UTF-8" LC_ALL="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_TYPE="en_US.UTF-8" TERM=xterm-256color
RUN locale-gen en_US en_US.UTF-8
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         vim \
         zip \
         wget \
         unzip \
         ca-certificates \
         libjpeg-dev \
         libpng-dev &&\
     rm -rf /var/lib/apt/lists/*


ENV PYTHON_VERSION=3.6

RUN curl -f -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda create -y --name pytorch-py$PYTHON_VERSION python=$PYTHON_VERSION numpy=1.14.5 scipy ipython mkl && \
     /opt/conda/bin/conda clean -ya

ENV PATH /opt/conda/envs/pytorch-py$PYTHON_VERSION/bin:$PATH

RUN /opt/conda/bin/conda install --name pytorch-py$PYTHON_VERSION cuda90 pytorch=0.4.1 torchvision -c pytorch && \
    /opt/conda/bin/conda clean -ya
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir tensorboard_logger
RUN pip install --no-cache-dir tqdm
RUN pip install --no-cache-dir h5py==2.7.1
RUN pip install --no-cache-dir boto3
RUN pip install --no-cache-dir -U scikit-learn
# install pytorch bert
RUN pip install --no-cache-dir pytorch-pretrained-bert==v0.6.0

# GLUE baseline dependencies
RUN pip install --no-cache-dir nltk
RUN pip install --no-cache-dir allennlp==0.4
RUN pip install --no-cache-dir ipdb
RUN pip install --no-cache-dir tensorboardX

WORKDIR /root
#COPY requirements.txt /root/
#RUN pip install -r requirements.txt
