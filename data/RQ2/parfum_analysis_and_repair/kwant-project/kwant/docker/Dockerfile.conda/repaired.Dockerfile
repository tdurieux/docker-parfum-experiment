FROM conda/miniconda3:latest

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        # all the hard non-Python dependencies
        git make patch build-essential \
        # Additional tools for running CI
        file rsync openssh-client \
        # Documentation building
        inkscape texlive-full zip librsvg2-bin \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY kwant-latest.yml kwant-stable.yml kwant-stable-no-extras.yml /

RUN conda env create -qf kwant-stable.yml
RUN conda env create -qf kwant-stable-no-extras.yml
RUN conda env create -qf kwant-latest.yml

RUN /usr/local/envs/kwant-latest/bin/python -m ipykernel install --user --name kwant-latest