FROM ubuntu:20.04 AS builder

LABEL maintainer="PharmAI GmbH <contact@pharm.ai>" \
        org.label-schema.name="PLIP: The Protein-Ligand Interaction Profiler" \
        org.label-schema.description="https://www.doi.org/10.1093/nar/gkv315"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    libopenbabel-dev \
    libopenbabel6 \
    pymol \
    python3-distutils \
    python3-lxml \
    python3-openbabel \
    python3-pymol \
    openbabel && rm -rf /var/lib/apt/lists/*;

# copy PLIP source code
WORKDIR /src
ADD plip/ plip/
RUN chmod +x plip/plipcmd.py
ENV PYTHONPATH $PYTHONPATH:/src

# execute tests
WORKDIR /src/plip/test
RUN chmod +x run_all_tests.sh
RUN ./run_all_tests.sh
WORKDIR /

# set entry point to plipcmd.py
ENTRYPOINT  ["python3", "/src/plip/plipcmd.py"]