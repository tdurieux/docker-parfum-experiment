# First, build a base image with miniconda, pudl-dev environment
# and all dependencies installed.

# Build pypi tarball from the local source
FROM python:3.8 AS pudl-pypi-builder
WORKDIR /pudl/repo
COPY . /pudl/repo
RUN mkdir /pudl/dist && mkdir /pudl/src
RUN python setup.py sdist -d /pudl/dist && mv /pudl/dist/*tar.gz /pudl/dist/pudl.tar.gz
RUN tar xzf /pudl/dist/pudl.tar.gz -C /pudl/src --strip-components=1 && rm /pudl/dist/pudl.tar.gz
RUN rm -Rf /pudl/repo

# Create pudl-dev environment based on the environment.yml from the source
FROM continuumio/miniconda3:latest AS pudl-conda-base
WORKDIR /pudl
COPY --from=pudl-pypi-builder /pudl/src/devtools/environment.yml .
RUN conda env create -f environment.yml

RUN echo "source activate pudl-dev" > ~/.bashrc
# ENV PATH /opt/conda/envs/env/bin:$PATH
SHELL ["conda", "run", "-n", "pudl-dev", "/bin/bash", "-c"]


# Copy source code and install pypi package with pip
FROM pudl-conda-base AS pudl-dev
WORKDIR /pudl/src
COPY --from=pudl-pypi-builder /pudl/src .
COPY --from=pudl-pypi-builder /pudl/dist/pudl.tar.gz /pudl/dist/pudl.tar.gz
RUN pip install --no-cache-dir /pudl/dist/pudl.tar.gz

RUN mkdir /pudl/inputs
RUN mkdir /pudl/outputs
RUN pudl_setup --pudl_in /pudl/inputs --pudl_out /pudl/outputs

# Mark inputs and outputs as mountable volumes
VOLUME /pudl/inputs/data
VOLUME /pudl/outputs

# Sets the default configuration to use with the release.
ENV PUDL_SETTINGS=/pudl/src/release/settings/release.yml
# TODO(rousik): Set default entrypoint to release/data-release.sh
# so that release is kicked off once this container is started.
