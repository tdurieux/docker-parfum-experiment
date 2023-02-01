FROM nvidia/cuda:10.2-devel

# Updating Ubuntu packages
RUN apt-get update && yes|apt-get upgrade
RUN apt-get install --no-install-recommends -y emacs && rm -rf /var/lib/apt/lists/*;

# Adding wget and bzip2
RUN apt-get install --no-install-recommends -y wget bzip2 && rm -rf /var/lib/apt/lists/*;

# Add sudo
RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;

# Anaconda installing
RUN wget https://repo.continuum.io/archive/Anaconda3-2020.02-Linux-x86_64.sh
RUN bash Anaconda3-2020.02-Linux-x86_64.sh -b
RUN rm Anaconda3-2020.02-Linux-x86_64.sh

# Set path to conda
ENV PATH /root/anaconda3/bin:$PATH

# Updating Anaconda packages
RUN conda update conda
RUN conda update anaconda
RUN conda update --all

# install build essentials
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y update

# copy RoutedFusion into image
COPY . /app
WORKDIR /app

## create anaconda environment
#RUN apt-get install -y mayavi2
RUN conda env create -f environment.yml
#
RUN echo "source activate routed-fusion" > ~/.bashrc
ENV PATH /root/anaconda3/envs/routed-fusion/bin:$PATH
#
RUN chmod +x /root/anaconda3/envs/routed-fusion/bin

# install all dependencies
RUN bash scripts/install_docker.sh
