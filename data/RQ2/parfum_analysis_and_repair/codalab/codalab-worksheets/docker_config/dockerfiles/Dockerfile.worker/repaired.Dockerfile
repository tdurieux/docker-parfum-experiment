FROM golang:1.15 as ecr-login-installation
# Install the Amazon ECR Docker Credential Helper
# Use Docker multi-stage builds to get rid of intermediate layers related to installation

ENV GOPATH /root/go
ENV SINGULARITY_VERSION=3.7.4

RUN mkdir -p /usr/local/var/singularity/mnt && \
    mkdir -p $GOPATH/src/github.com/sylabs && \
    cd $GOPATH/src/github.com/sylabs && \
    wget https://github.com/sylabs/singularity/releases/download/v${SINGULARITY_VERSION}/singularity-${SINGULARITY_VERSION}.tar.gz && \
    tar -xzvf singularity-${SINGULARITY_VERSION}.tar.gz && \
    cd singularity && \
    ./mconfig -p /usr/local && \
    make -C builddir && \
    make -C builddir install; rm singularity-${SINGULARITY_VERSION}.tar.gz

RUN go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login
WORKDIR /root/go/src/github.com/awslabs/amazon-ecr-credential-helper
RUN make

FROM ubuntu:16.04
MAINTAINER CodaLab Worksheets <codalab.worksheets@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
  apt-get install -y --no-install-recommends software-properties-common curl && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev \
    squashfs-tools \
    libseccomp-dev \
    pkg-config \
    zip \ 
    git \
    wget \
    unzip && \
    rm -rf /var/lib/apt/lists/*;

# Miniconda 4.5.11 installs Python 3.7 by default.
RUN curl -f -o ~/miniconda.sh -O  https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh
ENV PATH /opt/conda/bin:$PATH
RUN conda --version

COPY --from=ecr-login-installation /root/go/src/github.com/awslabs/amazon-ecr-credential-helper/bin/local /usr/local/bin
COPY --from=ecr-login-installation /usr/local/bin/singularity /usr/local/bin
# the singularity container runtime needs to be able to lookup the uid of the default user
#RUN useradd -ms /bin/bash $default_user

RUN mkdir $HOME/.docker
RUN echo "{\"credsStore\": \"ecr-login\"}" >> ~/.docker/config.json

WORKDIR /opt
RUN mkdir ${WORKDIR}/codalab
RUN mkdir ${WORKDIR}/scripts

# Install dependencies
COPY requirements.txt requirements.txt
RUN python3 -m pip install --user --upgrade pip==20.3.4; \
    python3 -m pip install setuptools --upgrade; \
    python3 -m pip install --no-cache-dir -r requirements.txt;

# Install code
COPY codalab/lib codalab/lib
COPY codalab/worker codalab/worker
COPY codalab/common.py codalab/common.py
COPY scripts/detect-ec2-spot-preemption.sh scripts/detect-ec2-spot-preemption.sh
COPY setup.py setup.py

RUN python3 -m pip install --no-cache-dir -e .

# Allow non-root to read everything
RUN chmod -R og=u-w .
# When running the worker container as a non-root user on the host,
# we need to create a user `codalab` in the Docker container that corresponds to the specified uid / gid.
# See https://medium.com/@mccode/understanding-how-uid-and-gid-work-in-docker-containers-c37a01d01cf
# the container, but we need to map to a default username. The underlying user is the same, just with
# different names.
RUN useradd codalab
