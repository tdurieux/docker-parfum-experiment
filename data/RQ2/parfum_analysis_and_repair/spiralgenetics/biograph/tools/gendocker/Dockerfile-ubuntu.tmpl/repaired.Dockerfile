FROM ubuntu:{TAG}

RUN apt-get update && apt-get install --no-install-recommends -y build-essential \
    python3 python3-dev python3-venv \
    zlib1g-dev \
    libbz2-dev liblzma-dev \
    liblapack-dev \
    bwa vcftools tabix && rm -rf /var/lib/apt/lists/*; # libbz2-dev and liblzma-dev are only required if htslib has to be
# compiled from source.
#
# liblapack-dev is only required if scikit-learn has to be compiled from source.








RUN useradd -m spiral
USER spiral
RUN python3 -m venv /home/spiral/venv
RUN . /home/spiral/venv/bin/activate && pip install --no-cache-dir --upgrade pip
