FROM ubuntu:{TAG}

RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update

# libbz2-dev and liblzma-dev are only required if htslib has to be
# compiled from source.
#
# liblapack-dev is only required if scikit-learn has to be compiled from source.

RUN apt-get install --no-install-recommends -y \
    build-essential \
    zlib1g-dev \
    libbz2-dev liblzma-dev \
    liblapack-dev \
    bwa vcftools tabix && rm -rf /var/lib/apt/lists/*;

# Store the non-python-version-specific packages in a separate layer to improve cacahability.

RUN apt-get install --no-install-recommends -y \
    python{PY_VERS} python{PY_VERS}-dev python{PY_VERS}-venv && rm -rf /var/lib/apt/lists/*;

RUN useradd -m spiral
USER spiral
RUN python{PY_VERS} -m venv /home/spiral/venv
RUN . /home/spiral/venv/bin/activate && pip install --no-cache-dir --upgrade pip
