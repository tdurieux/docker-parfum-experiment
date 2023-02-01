# Use nvidia/cuda image
FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04
CMD nvidia-smi
WORKDIR /home/ubuntu/workdir

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;

# Bash shell
RUN chsh -s /bin/bash
SHELL ["/bin/bash", "-c"]

# Install and update tools to minimize security vulnerabilities
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common wget apt-utils patchelf git libprotobuf-dev protobuf-compiler cmake && rm -rf /var/lib/apt/lists/*;
RUN unattended-upgrade
RUN apt-get autoremove -y

# Install anaconda
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git mercurial subversion && \
        apt-get clean && rm -rf /var/lib/apt/lists/*;
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
# Python and pip
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN apt-get install --no-install-recommends -y libopenmpi-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-mpi4py && rm -rf /var/lib/apt/lists/*;
# Clean up dependencies to only install necessary packages
COPY ort_train_env.yml .
RUN conda update conda \
	&& conda env create --name venv_ort -f ort_train_env.yml

RUN echo "source activate venv_ort" > ~/.bashrc
ENV PATH /opt/conda/envs/venv_ort/bin:$PATH
ENV CONDA_DEFAULT_ENV $venv_ort

# Install ort related dependencies
# PyTorch
RUN pip install --no-cache-dir onnx==1.9.0 ninja
RUN pip install --no-cache-dir torch==1.9.0+cu102 torchvision==0.10.0+cu102 torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html

# ORT Module
RUN pip install --no-cache-dir onnxruntime-training==1.9.0

RUN pip install --no-cache-dir torch-ort
RUN python -m torch_ort.configure

# Clone the optimum repo
RUN git clone https://github.com/huggingface/optimum.git && cd optimum

CMD ["/bin/bash"]
