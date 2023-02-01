FROM continuumio/anaconda3:latest

# enable shell for conda
SHELL ["/bin/bash", "--login", "-c"]
RUN conda init bash

# create conda env
RUN conda create -n package_env python=3.6.2

# install pytest
RUN conda activate package_env && pip install --no-cache-dir --user pytest

# install (only) requirements
COPY ./setup.py ./setup.py
COPY ./README.md ./README.md
RUN conda activate package_env && python setup.py egg_info && pip install --no-cache-dir -r *.egg-info/requires.txt

# copy files (as late as possbile to encourage caching)
COPY ./ ./

# install Ontolearn
RUN conda activate package_env && pip install --no-cache-dir -e .

# run tests
CMD conda activate package_env && python -m pytest --log-cli-level=INFO tests


