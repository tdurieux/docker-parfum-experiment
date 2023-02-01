FROM continuumio/miniconda3

# Create the environment:
RUN conda create -n condabuild -y -c conda-forge conda-build conda-verify anaconda-client git
RUN apt-get -y update && apt -y --no-install-recommends install patch && rm -rf /var/lib/apt/lists/*;
# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "condabuild", "/bin/bash", "-c"]

COPY . .

#RUN conda-build -c krande/label/dev -c conda-forge . --keep-old-work --python 3.9.10