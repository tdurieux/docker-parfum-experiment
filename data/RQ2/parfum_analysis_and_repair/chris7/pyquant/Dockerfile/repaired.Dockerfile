FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    gcc \
    gfortran \
    git \
    libxml2-dev \
    libxslt1-dev \
    python3-dev \
    python3-pip \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;


WORKDIR pyquant
COPY Makefile MANIFEST.in requirements.txt requirements-dev.txt setup.py setup.cfg tox.ini ./
RUN pip3 install --no-cache-dir -r requirements-dev.txt

COPY scripts scripts
COPY tests tests
COPY pyquant pyquant

RUN pip3 install --no-cache-dir -e .

ENTRYPOINT ["pyQuant"]
CMD ["--help"]
