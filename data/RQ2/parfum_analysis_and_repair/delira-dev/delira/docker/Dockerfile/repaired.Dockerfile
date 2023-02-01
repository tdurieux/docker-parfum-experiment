FROM nvidia/cuda:9.2-base-ubuntu18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
    build-essential \
    fonts-roboto \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash containeruser
USER containeruser
WORKDIR /home/containeruser

RUN curl -f -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p /home/containeruser/conda && \
    rm ~/miniconda.sh && \
    /home/containeruser/conda/bin/conda clean -ya
ENV PATH /home/containeruser/conda/bin:$PATH
RUN conda install python=3.7
RUN pip install --no-cache-dir --upgrade pip
RUN git clone https://github.com/justusschock/delira.git && \
    pip install --no-cache-dir pip wheel && \
    pip install --no-cache-dir -r delira/requirements.txt && \
    pip install --no-cache-dir -r delira/requirements_extra_torch.txt && \
    pip install --no-cache-dir delira/
ENV PYTHONPATH /home/containeruser/delira:$PYTHONPATH
CMD ["/bin/bash"]
