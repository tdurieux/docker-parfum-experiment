# This is meant to turn a conda environment.yml file into a container. To be used like:
# docker build -t image_name:tag --build-arg ENV_FILE=myenv.yml -f src/meadowrun/docker_files/CondaDockerfile .
# This assumes that ./myenv.yml exists and defines the environment

# this should be a continuumio/miniconda3, but latest/4.10 and 4.9 currently have a bug,
# 4.12 works
FROM hrichardlee/miniconda3

ARG ENV_FILE

WORKDIR /tmp/
COPY $ENV_FILE ./
# we would rather not assume that the name of the environment in $ENV_NAME.yml is the
# same as the filename, so we just hardcode a name here