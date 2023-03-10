# === Build Anaconda Environment ===
FROM continuumio/miniconda3 as conda-stage

# init
RUN apt-get update && apt-get upgrade -y
RUN conda update -n base -c defaults conda -y

# prepare
RUN apt-get install --no-install-recommends -y python3-opengl && rm -rf /var/lib/apt/lists/*;

# WORKDIR /tmp
COPY conda_envs/acinoset.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml
# Pull the environment name out of the environment.yml
RUN echo "source activate $(head -1 /tmp/environment.yml | cut -d' ' -f2)" > ~/.bashrc
ENV PATH /opt/conda/envs/$(head -1 /tmp/environment.yml | cut -d' ' -f2)/bin:$PATH


# === Deploy ===
FROM dorowu/ubuntu-desktop-lxde-vnc

# prepare conda
COPY --from=conda-stage /opt/conda /opt/conda
ENV PATH $PATH:/opt/conda/bin
# RUN /bin/bash -c "conda init bash"

# install opneGL
RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y python3-opengl && rm -rf /var/lib/apt/lists/*;
