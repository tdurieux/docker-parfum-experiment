FROM ubuntu:18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt-get update -y

RUN apt-get install --no-install-recommends -y wget build-essential && rm -rf /var/lib/apt/lists/*;

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh
RUN conda --version

# Adding conda environemnt
RUN mkdir -p /kmol
COPY ./environment.yml /kmol/

# Setting miniconda environment
WORKDIR /kmol
RUN conda env create --file environment.yml
ENV CONDA_DEFAULT_ENV kmol
RUN conda init bash
RUN echo "conda activate kmol" >> ~/.bashrc
ENV PATH /opt/conda/envs/kmol/bin:$PATH

# installation of torch-geometric
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
SHELL ["conda", "run", "-n", "kmol", "/bin/bash", "-c"]
RUN pip install --no-cache-dir torch-scatter==latest+cu102 -f https://pytorch-geometric.com/whl/torch-1.6.0.html --use-deprecated=legacy-resolver
RUN pip install --no-cache-dir torch-sparse==latest+cu102 -f https://pytorch-geometric.com/whl/torch-1.6.0.html --use-deprecated=legacy-resolver
RUN pip install --no-cache-dir torch-cluster==latest+cu102 -f https://pytorch-geometric.com/whl/torch-1.6.0.html --use-deprecated=legacy-resolver
RUN pip install --no-cache-dir torch-spline-conv==latest+cu102 -f https://pytorch-geometric.com/whl/torch-1.6.0.html --use-deprecated=legacy-resolver
RUN pip install --no-cache-dir torch-geometric==1.6.0

# Adding content
COPY ./setup.py /kmol/
COPY ./setup.cfg /kmol/
COPY ./pyproject.toml /kmol/
COPY ./src /kmol/src
RUN pip install --no-cache-dir -e .

COPY ./docker/*.sh /kmol/
SHELL ["/bin/bash", "--login", "-c"]
ENTRYPOINT ["/bin/bash", "--login", "/kmol/run.sh"]
