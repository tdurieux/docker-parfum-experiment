FROM continuumio/miniconda3

RUN apt-get -y update && apt-get -y --no-install-recommends install build-essential gcc && rm -rf /var/lib/apt/lists/*;

RUN conda install python=3.7 nomkl scipy numpy cython pip pytest

