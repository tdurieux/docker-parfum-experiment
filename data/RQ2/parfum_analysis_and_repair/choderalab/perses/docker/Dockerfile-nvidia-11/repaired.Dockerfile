FROM nvidia/cuda:11.2.2-runtime-ubuntu20.04

# Use bash for all RUN directives
SHELL ["/bin/bash", "-c"]

# Install wget and update OS packages
RUN apt update && \
    apt upgrade -y && \
    apt install --no-install-recommends -y wget && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Set language to make apk happy
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
# Name of conda env
# We use base so we don't have to remember to
# activate it
ENV ENV_NAME="base"
# Location of conda install
ENV MAMBA_ROOT_PREFIX="/opt/conda"
# Set home dir
ENV HOME="/home/micromamba"
# Tell bash which rc file to use
ENV BASH_ENV="$HOME/.bashrc"
# Ensure mamba installed binaries are in path
ENV PATH "$MAMBA_ROOT_PREFIX/bin:$PATH"

# Instead of using conda which is slow,
# We will use micromamba which is fast
# and quick to install and works like conda
# See https://github.com/mamba-org/mamba#micromamba for more details
RUN wget -qO- https://micromamba.snakepit.net/api/micromamba/linux-64/latest | tar -xvj bin/micromamba && \
    mkdir -p "$HOME" && \
    ./bin/micromamba shell init -s bash -p "$MAMBA_ROOT_PREFIX" && \
    echo "micromamba activate $ENV_NAME" >> "$BASH_ENV" && \
    chmod -R a+rwx "$HOME" "$BASH_ENV" "$MAMBA_ROOT_PREFIX" && \
    micromamba install -n "$ENV_NAME" -c jaimergp/label/unsupported-cudatoolkit-shim -c conda-forge -c openeye --strict-channel-priority --yes perses==0.9.2 openeye-toolkits && \
    micromamba clean -a

# Make directory and tell openeye where to find
# license file
RUN mkdir /openeye
ENV OE_LICENSE=/openeye/oe_license.txt
