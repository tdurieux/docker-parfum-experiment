# This is an example docker file that you can use to build your own docker
# image and then sync it with your docker repo.
# docker build -t chemprop --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)" .

FROM ubuntu as intermediate

# install git
RUN apt-get -qq update && apt-get -qq --no-install-recommends install -y git && rm -rf /var/lib/apt/lists/*;

# Add credentials on build
ARG SSH_PRIVATE_KEY
RUN mkdir ~/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > ~/.ssh/id_rsa

# Make sure your domain is accepted
RUN touch ~/.ssh/known_hosts
RUN chmod 600 ~/.ssh/*
RUN ssh-keyscan github.com >> ~/.ssh/known_hosts

ARG CACHEBUST=0
RUN git clone -b confidence-evidential --depth 1 git@github.com:aamini/chemprop.git
RUN rm -rf chemprop/.git

# Base Image on DRL image
FROM mitdrl/ubuntu:latest

# Copy and switch to repo directory
COPY --from=intermediate /chemprop /chemprop
WORKDIR /chemprop
RUN tar -xzf data.tar.gz && \
    chown -R madscientist:drl /chemprop && rm data.tar.gz

COPY data/docking-50k.csv /chemprop/data/docking-50k.csv


RUN apt-get -qq --no-install-recommends install -y nano tmux htop && rm -rf /var/lib/apt/lists/*;

# Prepare data and create conda environment
# RUN tar -xf data.tar.gz
# RUN conda install -n base pytorch -c pytorch
# RUN conda env update --name base --file environment.yml

# Update something to the bashrc (/etc/bashrc_skipper) to customize your shell
RUN echo -e "alias py='python'" >> /etc/bashrc_skipper
