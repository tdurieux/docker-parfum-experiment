FROM ubuntu:19.04

# Install tools needed for deployment
RUN apt update && \
    apt install --no-install-recommends -y \
        ca-certificates tree make git python3 curl && rm -rf /var/lib/apt/lists/*;

# Install Python versions needed
RUN curl -f -OL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -f && \
    ~/miniconda3/bin/conda create -n py3.6 python=3.6 -y && \
    ln -s ~/miniconda3/envs/py3.6/bin/python ~/python3.6
