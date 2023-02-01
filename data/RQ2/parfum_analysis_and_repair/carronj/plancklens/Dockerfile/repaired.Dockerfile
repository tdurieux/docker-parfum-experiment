# Dockerfile adapted from jupyter/scipy-notebook by Louis Legrand
# https://github.com/jupyter/docker-stacks/blob/master/scipy-notebook/Dockerfile

ARG OWNER=jupyter
ARG BASE_CONTAINER=$OWNER/scipy-notebook
FROM $BASE_CONTAINER

USER root


# We need a fortran compiler for plancklens
RUN apt-get update --yes && apt-get install --no-install-recommends gfortran --yes && rm -rf /var/lib/apt/lists/*;


# Install plancklens
WORKDIR "${HOME}"
COPY . "${HOME}/plancklens"
WORKDIR "${HOME}/plancklens"
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -e .

# Install lenspyx
WORKDIR "${HOME}"
RUN git clone https://github.com/carronj/lenspyx.git
WORKDIR "${HOME}/lenspyx"
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -e .

WORKDIR "${HOME}"


# Setting the plancklens env variable for writing stuff
ENV PLENS="${HOME}/plens_write"
