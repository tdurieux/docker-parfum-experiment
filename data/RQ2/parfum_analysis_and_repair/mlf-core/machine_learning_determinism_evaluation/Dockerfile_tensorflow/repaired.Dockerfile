From mlflowcore/base:1.0.0

# Install the conda environment
COPY tensorflow_environment.yml .
RUN conda env create -f tensorflow_environment.yml && conda clean -a

# Activate the environment
RUN echo "source activate tensorflow-2.2-cuda-10.1" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH

# ENV LD_LIBRARY_PATH "$LD_LIBRARY_PATH:/usr/local/cuda/lib64"
# ENV LD_LIBRARY_PATH "$LD_LIBRARY_PATH:/usr/local/cuda-10.1/compat"

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name tensorflow-2.2-cuda-10.1 > tensorflow-2.2-cuda-10.1.yml