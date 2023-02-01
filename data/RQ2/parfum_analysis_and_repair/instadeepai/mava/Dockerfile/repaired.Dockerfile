##########################################################
# Core Mava image
FROM nvidia/cuda:11.5.1-cudnn8-devel-ubuntu20.04 as mava-core
# Flag to record agents
ARG record
# Ensure no installs try launch interactive screen
ARG DEBIAN_FRONTEND=noninteractive
# Update packages
RUN apt-get update --fix-missing -y && apt-get install --no-install-recommends -y python3-pip && apt-get install --no-install-recommends -y python3-venv && rm -rf /var/lib/apt/lists/*;
# Update python path
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 10 &&\
    rm -rf /root/.cache && apt-get clean
# Setup virtual env
RUN python -m venv mava
ENV VIRTUAL_ENV /mava
ENV PATH /mava/bin:$PATH
RUN pip install --no-cache-dir --upgrade pip setuptools wheel
# Location of mava folder
ARG folder=/home/app/mava
## working directory
WORKDIR ${folder}
## Copy code from current path
COPY . /home/app/mava
# For box2d
RUN apt-get install --no-install-recommends swig -y && rm -rf /var/lib/apt/lists/*;
## Install core dependencies + reverb.
RUN pip install --no-cache-dir -e .[reverb]
## Optional install for screen recording.
ENV DISPLAY=:0
RUN if [ "$record" = "true" ]; then \
    ./bash_scripts/install_record.sh; \
    fi
EXPOSE 6006
##########################################################

##########################################################
# Core Mava-TF image
FROM mava-core as tf-core
# Tensorflow gpu config.
ENV TF_FORCE_GPU_ALLOW_GROWTH=true
ENV CUDA_DEVICE_ORDER=PCI_BUS_ID
ENV TF_CPP_MIN_LOG_LEVEL=3
## Install core tf dependencies.
RUN pip install --no-cache-dir -e .[tf]
##########################################################

##########################################################
# PZ image
FROM tf-core AS pz
RUN pip install --no-cache-dir -e .[pz]
# PettingZoo Atari envs
RUN apt-get update
RUN apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unrar-free && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir autorom
RUN AutoROM -v
##########################################################

##########################################################
# SMAC image
FROM tf-core AS sc2
## Install smac environment
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir .[sc2]
# We use the pz wrapper for smac
RUN pip install --no-cache-dir .[pz]
ENV SC2PATH /home/app/mava/3rdparty/StarCraftII
##########################################################

##########################################################
# Flatland Image
FROM tf-core AS flatland
RUN pip install --no-cache-dir -e .[flatland]
##########################################################

#########################################################
## Robocup Image
FROM tf-core AS robocup
RUN apt-get install --no-install-recommends sudo -y && rm -rf /var/lib/apt/lists/*;
RUN ./bash_scripts/install_robocup.sh
##########################################################

##########################################################
## OpenSpiel Image
FROM tf-core AS openspiel
RUN pip install --no-cache-dir .[open_spiel]
##########################################################

##########################################################
# MeltingPot Image
FROM tf-core AS meltingpot
# Install meltingpot
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN ./bash_scripts/install_meltingpot.sh
# Add meltingpot to python path
ENV PYTHONPATH "${PYTHONPATH}:${folder}/../packages/meltingpot"
##########################################################

# New Jax Images
##########################################################
# Core Mava-Jax image
FROM mava-core as jax-core
# Jax gpu config.
ENV XLA_PYTHON_CLIENT_PREALLOCATE=false
## Install core jax dependencies.
# Install jax gpu
RUN pip install --no-cache-dir -e .[jax]
RUN pip install --no-cache-dir --upgrade "jax[cuda]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
##########################################################

##########################################################
# PZ image
FROM jax-core AS pz-jax
RUN pip install --no-cache-dir -e .[pz]
# PettingZoo Atari envs
RUN apt-get update
RUN apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unrar-free && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir autorom
RUN AutoROM -v
##########################################################

##########################################################
# SMAC image
FROM jax-core AS sc2-jax
## Install smac environment
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir .[sc2]
# We use the pz wrapper for smac
RUN pip install --no-cache-dir .[pz]
ENV SC2PATH /home/app/mava/3rdparty/StarCraftII
##########################################################

##########################################################
# Flatland Image
FROM jax-core AS flatland-jax
RUN pip install --no-cache-dir -e .[flatland]
# To fix module 'jaxlib.xla_extension' has no attribute '__path__'
RUN pip install --no-cache-dir cloudpickle -U
##########################################################

#########################################################
## Robocup Image
FROM jax-core AS robocup-jax
RUN apt-get install --no-install-recommends sudo -y && rm -rf /var/lib/apt/lists/*;
RUN ./bash_scripts/install_robocup.sh
##########################################################

##########################################################
## OpenSpiel Image
FROM jax-core AS openspiel-jax
RUN pip install --no-cache-dir .[open_spiel]
##########################################################

##########################################################
# MeltingPot Image
FROM jax-core AS meltingpot-jax
# Install meltingpot
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN ./bash_scripts/install_meltingpot.sh
# Add meltingpot to python path
ENV PYTHONPATH "${PYTHONPATH}:${folder}/../packages/meltingpot"
##########################################################
