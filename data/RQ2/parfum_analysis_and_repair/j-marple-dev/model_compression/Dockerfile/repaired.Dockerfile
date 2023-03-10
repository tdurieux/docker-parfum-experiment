FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

# Install some basic utilities
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
 && rm -rf /var/lib/apt/lists/*

# Create a working directory
RUN mkdir /app
WORKDIR /app

# Create a non-root user and switch to it
RUN adduser --disabled-password --gecos '' --shell /bin/bash user \
 && chown -R user:user /app
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user
USER user

# All users can use /home/user as their home directory
ENV HOME=/home/user
RUN chmod 777 /home/user

# Install Miniconda and Python 3.7
ENV CONDA_AUTO_UPDATE_CONDA=false
ENV PATH=/home/user/miniconda/bin:$PATH
RUN curl -f -sLo ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-py37_4.8.2-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p ~/miniconda \
 && rm ~/miniconda.sh \
 && conda install -y python==3.7 \
 && conda clean -ya

# CUDA 10.2-specific steps and required library settings
RUN conda install pytorch==1.5.1 torchvision==0.6.1 cudatoolkit -c pytorch \
 && conda install -c conda-forge progressbar2 \
 && conda clean -ya

COPY requirements.txt $HOME/
COPY requirements-dev.txt $HOME/
RUN pip install --no-cache-dir -r $HOME/requirements.txt
RUN pip install --no-cache-dir -r $HOME/requirements-dev.txt

# Set the default command to python3
CMD ["python3"]
