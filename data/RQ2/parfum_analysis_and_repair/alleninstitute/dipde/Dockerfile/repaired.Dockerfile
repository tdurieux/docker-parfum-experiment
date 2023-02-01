#
# dipde miniconda Dockerfile
#
# https://github.com/nicain/dipde_dev

# Pull base image.
FROM continuumio/miniconda:4.1.11
ARG DIPDE_BRANCH=release_0.2.1

# Allows plotting tests
RUN apt-get install --no-install-recommends -y xvfb && rm -rf /var/lib/apt/lists/*;
USER root
SHELL ["/bin/bash", "-c"]

RUN wget https://raw.githubusercontent.com/nicain/dipde_dev/$DIPDE_BRANCH/environment.yml
RUN conda update -y conda
RUN conda env update -f environment.yml -n root
RUN pip install --no-cache-dir https://github.com/nicain/dipde_dev/zipball/$DIPDE_BRANCH

# Should pass all tests when image is built
RUN /usr/bin/xvfb-run py.test /opt/conda/lib/python2.7/site-packages/dipde/test 2> /dev/null
