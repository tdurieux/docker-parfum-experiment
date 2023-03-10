From mlflowcore/base:1.0.0

# Install the conda environment
COPY xgboost_environment.yml .
RUN conda env create -f xgboost_environment.yml && conda clean -a

# Activate the environment
RUN echo "source activate xgboost-1.0.2-cuda-10.1" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name xgboost-1.0.2-cuda-10.1 > xgboost-1.0.2-cuda-10.1.yml