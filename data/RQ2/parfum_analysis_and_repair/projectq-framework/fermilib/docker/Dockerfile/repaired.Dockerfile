# Dockerfile for FermiLib+ProjectQ

# Change the following line to "FROM continuumio/anaconda" to use Python 2
FROM continuumio/anaconda3

USER root

RUN apt install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir git+https://github.com/ProjectQ-Framework/ProjectQ.git && \
    pip install --no-cache-dir git+https://github.com/ProjectQ-Framework/FermiLib.git

