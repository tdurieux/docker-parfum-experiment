FROM ubuntu:bionic
MAINTAINER Hisanari Otsu <hi2p.perim@gmail.com>

# Change default shell to bash
SHELL ["/bin/bash", "-c"]

# System packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install --no-install-recommends -y \
    tmux \
    vim \
    curl \
    git \
    git-lfs \
    software-properties-common \
    build-essential \
    doxygen \
    graphviz && rm -rf /var/lib/apt/lists/*;

# Install miniconda
WORKDIR /
RUN curl -f -OJLs https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b
ENV PATH /miniconda/bin:$PATH

# Setup lm3_dev environment
COPY environment.yml environment.yml
RUN conda env create -f environment.yml
RUN echo "source activate lm3_dev" > ~/.bashrc
ENV PATH /opt/conda/envs/lm3_dev/bin:$PATH

# Install binary dependencies of imageio
RUN source ~/.bashrc && imageio_download_bin freeimage

# Expose port for Jupyter notebook
EXPOSE 8888

# Default command
CMD ["/bin/bash"]