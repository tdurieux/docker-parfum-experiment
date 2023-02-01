FROM continuumio/miniconda3

# init
RUN apt-get update && apt-get upgrade -y
RUN conda update -n base -c defaults conda -y

# prepare
RUN apt-get install -y python3-opengl

# WORKDIR /tmp
COPY conda_envs/acinoset.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml
# Pull the environment name out of the environment.yml
RUN echo "source activate $(head -1 /tmp/environment.yml | cut -d' ' -f2)" > ~/.bashrc
ENV PATH /opt/conda/envs/$(head -1 /tmp/environment.yml | cut -d' ' -f2)/bin:$PATH