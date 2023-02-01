# Use nvidia/cuda image
FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04
CMD nvidia-smi

# Bash shell
RUN chsh -s /bin/bash
SHELL ["/bin/bash", "-c"]

# Temporary fix until NVDIA finish the update of its docker images
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;

# Install and update tools to minimize security vulnerabilities
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common wget apt-utils patchelf git libprotobuf-dev protobuf-compiler cmake \
    bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 mercurial subversion libopenmpi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN unattended-upgrade
RUN apt-get autoremove -y

# Install conda
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git mercurial subversion && \
        apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends sox ffmpeg libcairo2 libcairo2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends texlive-full && rm -rf /var/lib/apt/lists/*;
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh -O ~/anaconda.sh && \
        /bin/bash ~/anaconda.sh -b -p /opt/conda && \
        rm ~/anaconda.sh && \
        ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
        echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
        find /opt/conda/ -follow -type f -name '*.a' -delete && \
        find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
        /opt/conda/bin/conda clean -afy

ENV PATH /opt/conda/bin:$PATH

# Create the environment:
RUN conda update conda \
	&& conda create -n venv_ort python=3.8 pip

RUN echo "source activate venv_ort" > ~/.bashrc
ENV PATH /opt/conda/envs/venv_ort/bin:$PATH
ENV CONDA_DEFAULT_ENV $venv_ort

# Install onnxruntime-training dependencies
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir manimlib manimce
RUN pip install --no-cache-dir onnx==1.10.2 ninja
RUN pip install --no-cache-dir torch==1.9.0+cu102 torchvision==0.10.0+cu102 torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install --no-cache-dir onnxruntime-training==1.11.0 -f https://download.onnxruntime.ai/onnxruntime_stable_cu102.html
RUN pip install --no-cache-dir torch-ort
# RUN python -m torch_ort.configure

WORKDIR .

CMD ["/bin/bash"]
