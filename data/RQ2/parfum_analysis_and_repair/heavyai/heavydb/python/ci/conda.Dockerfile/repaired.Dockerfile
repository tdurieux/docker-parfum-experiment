FROM continuumio/miniconda3

WORKDIR /heavydb

RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# Create the environment:
COPY environment.yml .
RUN conda env create -f environment.yml

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "heavydb-dev", "/bin/bash", "-c"]

ENTRYPOINT pip install -e .; pytest -x tests
