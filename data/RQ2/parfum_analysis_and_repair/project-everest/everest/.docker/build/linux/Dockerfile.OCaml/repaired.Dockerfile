# This Dockerfile is meant to test several OCaml versions.
# It must be loaded from the everest repository root
# (NOT from the directory that contains the Dockerfile)

FROM ubuntu:22.04

# Install the dependencies of Project Everest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get --yes install --no-install-recommends opam gcc binutils make m4 git time gnupg ca-certificates sudo cmake curl wget && rm -rf /var/lib/apt/lists/*;

# Install .NET Core, following https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu
RUN apt install --no-install-recommends -y gnupg ca-certificates wget && \
    wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install --no-install-recommends -y apt-transport-https && \
    apt-get update && \
    apt-get --yes install --no-install-recommends \
    dotnet-sdk-6.0 && rm -rf /var/lib/apt/lists/*;

# Install NodeJS 16
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;

# Create a new user and give them sudo rights
RUN useradd -d /home/test test
RUN echo 'test ALL=NOPASSWD: ALL' >> /etc/sudoers
RUN mkdir /home/test
RUN chown test:test /home/test
USER test
ENV HOME /home/test
WORKDIR $HOME
SHELL ["/bin/bash", "--login", "-c"]

# Install OCaml
ENV OPAMYES 1
ARG OCAML_VERSION=4.12.0
RUN opam init --compiler=$OCAML_VERSION --disable-sandboxing
RUN opam env --set-switch | tee --append $HOME/.profile $HOME/.bashrc $HOME/.bash_profile

# Add Everest files and projects

# Alternative 1: use the current clone
ADD --chown=test . .
ENV EVEREST_DIR $HOME

# Alternative 2: use a fresh clone
# ENV EVEREST_BRANCH=master
# RUN git clone --branch $EVEREST_BRANCH https://github.com/project-everest/everest everest
# ENV EVEREST_DIR $HOME/everest

# Clone Everest subprojects
WORKDIR $EVEREST_DIR
RUN ./everest --yes reset

# Check that all Everest dependencies are correctly installed
ARG EVEREST_THREADS=24
RUN ./everest --yes -j $EVEREST_THREADS check

# Make Everest
RUN ./everest --yes -j $EVEREST_THREADS make

# Test Everest
RUN ./everest --yes -j $EVEREST_THREADS test
