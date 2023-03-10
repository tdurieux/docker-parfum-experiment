From mlflowcore/base:1.0.0

# Install the conda environment
COPY pytorch_environment.yml .
RUN conda env create -f pytorch_environment.yml && conda clean -a

# Activate the environment
RUN echo "source activate pytorch-1.5-cuda-10.1" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name pytorch-1.5-cuda-10.1 > pytorch-1.5-cuda-10.1.yml